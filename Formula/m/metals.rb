class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  # TODO: Check if we can use unversioned `openjdk` (or `openjdk@21`) at version bump.
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "267cb6c3b1fcd4dd73e001d8daf889f56cd6e9f507d48ab5e619d2fba842d882"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d62c0d37054b1853fb0e4dd6e1499caed7136ccbe2959e2fe5591931dfe59216"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "463c811dd60648ea2ead2757c2e41c4c292f9742feb70338501f93c744868f4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70d74338c4928fd819ac7345bd27fc0001a0dfba0b7359e7a1a57cd72e83dd11"
    sha256 cellar: :any_skip_relocation, sonoma:         "8559671f3cb42e1844fb3de217ab385e374a3566d717822a6c12f762baa40a1a"
    sha256 cellar: :any_skip_relocation, ventura:        "a181c38b284d1c412e4b6ba9f90fa364384bc248b840b59d1f570c6856e04933"
    sha256 cellar: :any_skip_relocation, monterey:       "b0123ce6719d0fe2494f54b3898b7086a582191dfb23d775ccf25019a9902f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a403f1df59c292cedbc6ace0c39bdf8db1c36f8f0ed3f15539e1dd65365e6a56"
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
