class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "c4fc0d6787afe4aeb2e06319f40765b791cf11e96645e6c88dc793b6bdd04b48"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "12d344ae69202cdeb605e0a4935f797069835123d836094512fd19bd1f0c3c24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf7dcf787a89ce512507c273758814a3825fa3d044fd58cc2838d76660c28d01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc35a564f9d6c4d34ab3c42d4b8f376cf83049db30135523ffd5e48654076c10"
    sha256 cellar: :any_skip_relocation, sonoma:         "d67aa49bbf9eb140f88d34bd33d8bddd64e2a069ca6ec7f8fd0a848b52659aa1"
    sha256 cellar: :any_skip_relocation, ventura:        "4c4bc35bb8488f38dd9ff68bbf2358d99f452681e7d4443974b3b325f5c5e06c"
    sha256 cellar: :any_skip_relocation, monterey:       "dcf80e20ae4654954c07266f311968518ad2c693c38064b549172601cf37be88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45e7dde766103c307f26b05bf44269f0d58a0eab1ed535c3bf55a50383ddfb96"
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
    Open3.popen3("#{bin}/metals") do |stdin, stdout, _e, w|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
      Process.kill("KILL", w.pid)
    end
  end
end
