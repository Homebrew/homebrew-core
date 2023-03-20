class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v0.11.11.tar.gz"
  sha256 "99c03bd5f6f6d3aa68d684f016ab6bb09175fa67953ddaa362f8a936bb3da72f"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e0c3616186a0ff1cc299acda01a311d1e06518b2cb100665c7ed5359c5744fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97a5e3e083acaedb1d8b3c971e684232d9d4fc9ca81617bed820f2bed3f28332"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d3e4a92a34c8abf89bcc4e44e366ea2b4a86e4e8140495e3336602cd3bded2a"
    sha256 cellar: :any_skip_relocation, ventura:        "826789d9fd5f6afe75185d56fe8e7d00653489abfecd95f8eb00428225dab732"
    sha256 cellar: :any_skip_relocation, monterey:       "36b99f076cea687011a4d6821ae1d7a1646d469c8c39e00dd6179f630646fdb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8a8e5bba8dcb2813ca2994468d3e5b38212f033c196004ecd5340218839f327"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14a4192df56f7015786392bdd07aa5d6068c79b557ae3c74c6dd36926ea37c40"
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
