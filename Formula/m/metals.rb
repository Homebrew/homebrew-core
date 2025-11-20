class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "5e6147091340ebfac1037a30af225d7684b1022e49f52a55268444b51fa12a4c"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8629460eb8e87dac5e495b1b04f1bc11d080ace5b01de68da14ebac59b66f968"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b76dacfe107ba418b52414efe52a5d33519d675c26ae717ce771ab914908171e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4458fcba1a74cd770139e05b3fedc2816a36e749572e7911e0ba1025953e5f31"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef3df00b0d625c6e1aeb3d6daa6bff9fdb35d353a7405e8a70ad2f1ebd40b6ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f8ff6636a39800500564f07cc16a68147b2a8505f2093f89c88346fdc8489ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "942eb69772978c373cf56ddf1d826729a51bb75a8318011ad7a054666e6ce557"
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
    deps_jars = sbt_deps_output.lines.grep(dep_pattern) { |line| line.strip.gsub(dep_pattern, '\1') }
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
