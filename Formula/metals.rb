class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v0.11.12.tar.gz"
  sha256 "9e50e557980891b9d24ac8ccb9922886b974d99247d1c0592e2e4385a789f338"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81d7a33ba04fd043655710cb69481c18a050ab7470cbdb353645e51aafb7c0b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b9c6c083a893f146b0e4581636290c18156116b56682fe85e8a4110b8d0934d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00d225d1e77804acc03140d03a05e278f5930dc36c25b82e217f69afc9dcc907"
    sha256 cellar: :any_skip_relocation, ventura:        "af113fa57bccd2656f76daae923bd8e65201c9450293110ccf2ab7f354c3e159"
    sha256 cellar: :any_skip_relocation, monterey:       "3cc3aa493fe3c42cc3f76773cc0a5f4d4a9dc28fbeb466a3af4421680c9d2851"
    sha256 cellar: :any_skip_relocation, big_sur:        "fda5fbffc5b146483318de303a11dc97fb9871367391d4c259e8bb2631b9bc51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d42a4dfe2cf807f58f2cb9ef45a063034d45c989848e55450484355d7e94b414"
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
