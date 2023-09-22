class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  # TODO: Check if we can use unversioned `openjdk` (or `openjdk@21`) at version bump.
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "5912c3cf0a8c2e430a6733998445b724b2f8192cccc8afe5816daa5146753d1f"
  license "Apache-2.0"
  revision 1

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b32885725341ab3cbacbf30beffcfce7e6ac86eb8078b49148e71a469bc22a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b3cfeb7071944f3641968372235a47c3f4c871e229d6103043615b3e4341132"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "931aa55a8ad851b6f7da59f0b241ed4a3da67fd92ebd3ef3d842046a0ef6e829"
    sha256 cellar: :any_skip_relocation, ventura:        "a592d1973c3a7136d77d8732c43ae485f9a768bf3a1d84db1780d34aa0352212"
    sha256 cellar: :any_skip_relocation, monterey:       "5c56392bbb2ca4913359c7e78c8ed5a377af5e7dbbbdbd071570813fddca049d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b424547318a9b7dc694918f797aa53a9bd7c5384217a0dbf3df7f9bfb75421d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56516bf1fedc5fa187e525867290ffcee070b4f50d8edf8208c9607d3ddaf821"
  end

  depends_on "sbt" => :build
  depends_on "openjdk@17"

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
    env = Language::Java.overridable_java_home_env("17")
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
