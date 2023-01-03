class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v0.11.10.tar.gz"
  sha256 "18bcdb08aca2a38409e4af03f1108611285c1d20b9044e5cf2ecd8efa5fc60a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af0aab78c9f08522521bec02f470cafe42c1fda392b6aebb9d15eab2cdbafcd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55ea716a02233e3592d969963eec30431bd595a2c671178215bbf69d067aa650"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fedb89491f5f2cd161f183bf3d3e7318d31614f992226bf50a7c0bf447152ddb"
    sha256 cellar: :any_skip_relocation, ventura:        "dbf7b9a46a3fa95041d9fc236b2bd16ecaf331cca581845b1eb4745e01c90b33"
    sha256 cellar: :any_skip_relocation, monterey:       "da3664ae3017b4ad1155f756fbe33a1f69a87666e4df2a9f7010e9b87267c72f"
    sha256 cellar: :any_skip_relocation, big_sur:        "95bcd513e9f2ed20ed9ef86cd82a3d983da1c2f7bbc09ddf79d2c9a04a1610e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58bbbeb4a43e496b6c379122f65a49ae48309a968a7a43a4c06cca94680597d3"
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
