class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "96fde076ec2441fb98346819b32ef6ef06e7603d4c28ac2479838aa8a636fc1d"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff4a4dd8cf0aecdc6f5b69bf21c4c53c6e24cd5ad2c05229e3f5372b37460e41"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d999994dd065e6dce8ca09109e759f93d6019f0683175d402dedecc129f4d883"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "923c7c8a5817117ed18236c1900787ab289e100d98c17b5abc3f6cf7a65f5a47"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b16f515194daa445a4b7ed35100c8614f61a790e1263d6a9720110304db1e9e"
    sha256 cellar: :any_skip_relocation, ventura:        "3474d477e497aa8c59ab2d15b47fa177f8ddc894816bedaf6f93492ad491c034"
    sha256 cellar: :any_skip_relocation, monterey:       "8be6609e71b0e2c023b2147c66ac6386658c02c6ca3e46d0b77e5abb0ae7b01a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8406c7c331063be60732b5b572da234a8b27247acb13d8ebb1e431e7065108b"
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
