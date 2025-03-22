class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "18129489076b71428131af22a81a4e1e6b1b5ef879fcff74429cf822617fec5c"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fadf1d0d19ba2deb8c7ef3f7ad7b7c3e40b00540a5af933b3364df62be1a34f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "203741e97a0af5334c3716fc88237a871fa81b9b7e6e880f26955ece8f5575ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f4e6d2a638380812ecb24695da15b56d5c1a86259436984352b0ce9ecbcacdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ae82a3c64b1925d4c1f672fea06bef32fd2f2155bdf03497490d355870376a0"
    sha256 cellar: :any_skip_relocation, ventura:       "cbce8c9e8c771b705fa32a5469cc7ba0a53735d51369aaf070f6a29818570d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "341db3cd37d058d417787c218166b817bbcff9d6d899e0435cb23974f4373f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a8e1c6c0396e8541d3666a79ec6b9893655f47e3ca47c38188e9fbb193c639c"
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
