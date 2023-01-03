class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v0.11.10.tar.gz"
  sha256 "18bcdb08aca2a38409e4af03f1108611285c1d20b9044e5cf2ecd8efa5fc60a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9da7788da6c9110a23572c8684427f315ad60c8b25ef330a9a0a9c0de6312756"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7c65425141c48a074d3df2784fa064a8def4563c997be1af37ab9239cdbe837"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02cca9ff46fd2e7a7a44889088a1d2e19d361910709ec559da2db85e5715a872"
    sha256 cellar: :any_skip_relocation, ventura:        "68ccef84d5a2b1fdc63ed6563ee42ca949aa2ea394dd9363b747ea87d9c0d6c4"
    sha256 cellar: :any_skip_relocation, monterey:       "234254769de9d71391e33776f3ce485da1d94a5f508b24efc5d3e8edeb93406d"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb94192ade2c871662e435ced28054fb26cc919411463a30de8eee725e1ad8c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc81cb083c46dcb021629981c39d4bdf185aca21bf22a358e38dcac66416d323"
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
