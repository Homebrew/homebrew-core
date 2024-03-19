class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "8c342965383406e28799187b4ca5349c8f486171da31ecca56bc197f2b8d1c14"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97aa97b672573798a8f45151e88a916ba77eb652733d05dc98595ea79af3a130"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f9e4ee0874df198ec2067453d6671c9a8a8fad3cb863a38fd8f35d2c9f8c68c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11813cf531811ea79568f6435942039889a1f9c77157375e021dd11720a0fd48"
    sha256 cellar: :any_skip_relocation, sonoma:         "39a921370ee89f6f8ca92530e01beeeae97bd7aaf33f9a41502cd94fef25d6e1"
    sha256 cellar: :any_skip_relocation, ventura:        "b8b5a2a3918a4296ae1fd868b2960a0e234a66df606313529ff096af2142c58f"
    sha256 cellar: :any_skip_relocation, monterey:       "9765ef6cd331bd28bd93dbb9771235815bebb5bb5ea435ddf50a020d5a0445f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "847e635336d46ab4572b69c42315ab08d8ac28751c304890948df92f30d891f2"
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
