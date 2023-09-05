class Metals < Formula
  desc "Scala language server"
  homepage "https://github.com/scalameta/metals"
  url "https://github.com/scalameta/metals/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "5912c3cf0a8c2e430a6733998445b724b2f8192cccc8afe5816daa5146753d1f"
  license "Apache-2.0"

  # Some version tags don't become a release, so it's necessary to check the
  # GitHub releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45a8d676623c648f8e044740581eed141b9c3c9cb44390d9a8fea93245a3ee35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df24d6089b05dd36f70c5ddef9d5e4b5f67f26b4a90f3f274a8d5486c4bcd921"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "615357cef8e311eb10c1a12270592fac1bcc91f6d00151a8c155f389a39bbc7e"
    sha256 cellar: :any_skip_relocation, ventura:        "61afda419671f1d1c861ff14bbb46c00e0baf036b04d16d350e74ea4129714a2"
    sha256 cellar: :any_skip_relocation, monterey:       "0040094eb013c1476996dd41e567a8d71d8de0f997419079b87aa8a0ff27ec9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4d13b7cdb2237d9e0378913788948da8570e87ddb565e09cd811af3a9f9f06c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec2c9aeaac536c89b33b1c094fd1288e686eca551a17d9723063e76a5163cc6e"
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
