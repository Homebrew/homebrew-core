class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "e0b9f77d3a796c93c4294897d0a1ec15e399770107b9a20192db8736ae11eaa7"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ced8731b756b7d256a0ee5a08310716cfd1758d601328aa685a5e66de72525e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92ddc2f9661e649016cc4892dc4a72e8cecfb2ac0bf9988ed6bba5176ca44794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c57e41618a1cef5b10f8dd33e2f8331aa6604cce4f1375e189fe10d24d87453"
    sha256 cellar: :any_skip_relocation, sonoma:        "7470c10aeeea77eb27afff32d82aa2b53abfea740b8f810fa74f34ffec2e7ad9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a15165e2fc0aaebb1a40aef8abafd4cc5d6a43d1fa2bb298dad5645ea5e1d77a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9984656b6707e7ccbe821a23517ea5d0b235e36f04aa9829e171ba21bb547ab"
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
