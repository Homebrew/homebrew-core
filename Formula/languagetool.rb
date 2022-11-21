class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v5.9",
      revision: "f8931bebf2f654974620baa179ce856f94dc776a"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7acf8bc0f9ce92f28d9eaa8b9e0f277155723c0d340e602084eff8f5c299ae1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a547119fbcadfa0929159a2e21fbc70d3c767aaa45c731e2cf98cc8bea0ee182"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0511102dd9fe9218e35dd89dd76cc5625d331d6c9d31f36bf4c2fe6d7bfdc709"
    sha256 cellar: :any_skip_relocation, ventura:        "5ec6d3e5d177ee966d1a73e63bb5d74f448d01a956f5b41a979c79cbdffabc6e"
    sha256 cellar: :any_skip_relocation, monterey:       "832468757ace167aa5948b5b67d9e525666328a1ec715d8fb17be477baddb167"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8183f7c15a75d3a712a02c0e579e08bfe1ba2f0d6d91adb37775dce7f0cf4cf"
    sha256 cellar: :any_skip_relocation, catalina:       "cc9e47cf0a201c68c2a0565a41621c0448a3fbf92006c1c0fb1f4ceca32047aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dce46230a1c6d197402f69d2d2c686728899c0356f1073c5464d58d1395ca60"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    java_version = "11"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)
    system "mvn", "clean", "package", "-DskipTests"

    # We need to strip one path level from the distribution zipball,
    # so extract it into a temporary directory then install it.
    mktemp "zip" do
      system "unzip", Dir["#{buildpath}/languagetool-standalone/target/*.zip"].first, "-d", "."
      libexec.install Dir["*/*"]
    end

    bin.write_jar_script libexec/"languagetool-commandline.jar", "languagetool", java_version: java_version
    bin.write_jar_script libexec/"languagetool.jar", "languagetool-gui", java_version: java_version
    (bin/"languagetool-server").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Language::Java.overridable_java_home_env(java_version)[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" -cp "#{libexec}/languagetool-server.jar" org.languagetool.server.HTTPServer "$@"
    EOS
  end

  service do
    run [bin/"languagetool-server", "--port", "8081", "--allow-origin"]
    keep_alive true
    log_path var/"log/languagetool/languagetool-server.log"
    error_log_path var/"log/languagetool/languagetool-server.log"
  end

  test do
    (testpath/"test.txt").write <<~EOS
      Homebrew, this is an test
    EOS
    output = shell_output("#{bin}/languagetool -l en-US test.txt 2>&1")
    assert_match(/Message: Use \Wa\W instead of \Wan\W/, output)
  end
end
