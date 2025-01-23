class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "327fc11a3ce0f804113eddafc5a8977dffc095840d1096c5b7b52caa63dc70bf"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8805ac62aa9ccec4da3ca25345fce02a7a8ecaf5db7940b079156a6d0bb135df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8226d4cf595401268ce0887b263dbb780422742fabdf25f4aeff91bc7995f0d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5865681a6b8d3158147ec85fde59b91032e09f647371e22ffc46438e2deeba15"
    sha256 cellar: :any_skip_relocation, sonoma:        "76ae3fdd5a063167739e1afc4f5d8ca8f106e5d43a5420dbd8606b278453f9e3"
    sha256 cellar: :any_skip_relocation, ventura:       "d502d18ccf63b509a11059dd4e65e60fed54407a69294350945982ead19d79e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30b4b3930781224e2affc836c3e7edf4cc4b7dafb0add55909c21143998ea4ec"
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
