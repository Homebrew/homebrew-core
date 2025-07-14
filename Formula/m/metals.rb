class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "dd46cccb9ca716e5814f4d75fed8e054da907be5c332403552f492d447faa40c"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c00e9f28c10edccfe1fc505d060b4f3d35b8848331308d4a2a4d3a91ed2cb10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3e473634629b8c93496d9c9112ce78103907adcd7a04ca0f1e02844ffaf2020"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ea45c3d40c637347ad7dba7e97268127bfe7e8edb438f564b9d3f8062bb055e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5a5eead1a84d975055510e899b31fa8e165aa3911a00579262dfe0b9da33bf5"
    sha256 cellar: :any_skip_relocation, ventura:       "329928b4de7ec712f1fdaafcfe65001d1204ca84024c121bbabdcbb19d659ef6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0be5303ea2086fcaa7f2d8c0cd8af9802725e6f2a60782f1d4341a6fe92e7341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a61b7cfc5d3c502a3a2bbdad979a68e52495ddc6ba512ef96ef3f13904725491"
  end

  depends_on "sbt" => :build
  depends_on "openjdk"

  def install
    ENV["CI"] = "TRUE"
    inreplace "build.sbt", /version ~=.+?,/m, "version := \"#{version}\","

    system "sbt", "package"

    # Following Arch AUR to get the dependencies.
    dep_pattern = /^.+?Attributed\((.+?\.jar)\).*$/
    sbt_deps_output = Utils.safe_popen_read("sbt 'show metals/dependencyClasspath' 2>/dev/null")
    deps_jars = sbt_deps_output.lines.grep(dep_pattern) { |it| it.strip.gsub(dep_pattern, '\1') }
    deps_jars.each do |jar|
      (libexec/"lib").install jar
    end

    (libexec/"lib").install buildpath.glob("metals/target/scala-*/metals_*-#{version}.jar")
    (libexec/"lib").install buildpath.glob("mtags/target/scala-*/mtags_*-#{version}.jar")
    (libexec/"lib").install buildpath.glob("mtags-shared/target/scala-*/mtags-shared_*-#{version}.jar")
    (libexec/"lib").install "mtags-interfaces/target/mtags-interfaces-#{version}.jar"

    args = %W[-cp "#{libexec/"lib"}/*" scala.meta.metals.Main]
    env = Language::Java.overridable_java_home_env
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"metals").write_env_script "java", args.join(" "), env
  end

  test do
    require "open3"
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    Open3.popen3(bin/"metals") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end
