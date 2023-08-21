class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "4ed800e189546ea8c97f7fd4c866fed85921ad8b6449f1c9aecd4d885bea3dce"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba58acd84ef04ef3b0c1789b126d6b82fd949cb0153237138cbd09ec56bf9b79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "755a702265c160ceade1775fcb8c04af11c8aa2988edc7c6e91e2c631f4a773a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a7fd3b3783c6c2766d9c618f1035d87cbb53ec8caa4de94ebb1f884e142a055"
    sha256 cellar: :any_skip_relocation, ventura:        "9f559c018b08791bf49bdfe9c2712d63b7cb9e14b54b60677f6280c355894a3c"
    sha256 cellar: :any_skip_relocation, monterey:       "1ffbcc653ad9b3c46b6ba3bb6822dade65abfa167ee4b44f168ee07c6ad73e72"
    sha256 cellar: :any_skip_relocation, big_sur:        "7af649e156a418c0d6268f9002c5a57d629d36715f2af40b672df7773a3325a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9695fb20f447e6c01ec220d1bd6f6a457e3a86fb9fd9c1e1de51f3b84c22e1e7"
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

    (bin/"metals").write <<~EOS
      #!/bin/bash

      export JAVA_HOME="#{Language::Java.java_home}"
      exec "${JAVA_HOME}/bin/java" -cp "#{libexec/"lib"}/*" "scala.meta.metals.Main" "$@"
    EOS
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
