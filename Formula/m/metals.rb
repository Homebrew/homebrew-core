class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.3.5.tar.gz"
  sha256 "9715cc653a22b7ce27d2abbfc2d62043092047e9554e981828a6a64c1bec4bf1"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "15efeb2e4a9dbe10c20faf792a9dd8652eb640c95a0193e53dbc547f7faadda0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e339283d6dbcf4d6c2183468dac067b51976bf463e9f3758abbb6817d669445"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ad0aa2ffd7d6e70c4aff59f26b45883c520fabf9949edacb3748bcec1d30e38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0a976e4cdf64bba7eb2d39056545aec241f25f107fb21e43a79b70905ec3ce6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a840558cb33e025524d1da58aa96120bd6746c78289f7a4afebe885b83a7569d"
    sha256 cellar: :any_skip_relocation, ventura:        "93d30b9aa4ad8a3e6a4387686f141dd2226ca0adab0fab00626d3d55b88fa2e3"
    sha256 cellar: :any_skip_relocation, monterey:       "fb711f2dc6831321eb258090f424a76e321e46b6d1dd9ebfc26a981ef7eb0b89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5233e4401b0d1fe5d1984ab0472b83af60f0d8c539a0f74b25de15f37443be94"
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
