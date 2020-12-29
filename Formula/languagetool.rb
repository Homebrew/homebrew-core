class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v5.2",
      revision: "eb572bf077c1873424ab18b99215f77b5c5d482d"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git"

  livecheck do
    url :head
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5055fc330b930efe7171a32c57d53ad46b3359cd9d000110a07ddd054f2d9d16" => :big_sur
    sha256 "6bde80d183c16d84c92986042edcf4f3baa383ae072251e9826fbaa2ccfb4860" => :catalina
    sha256 "78995e979adc689bbb988a0242094c76289a3f24e61f3d38766a8825877c5ab5" => :mojave
    sha256 "727ec2c9a799ab437f0764b06bc30203de405dd47571cb52091a0ca2f75a78a2" => :high_sierra
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

  test do
    (testpath/"test.txt").write <<~EOS
      Homebrew, the missing package manager for macOS.
    EOS
    assert_match /Homebrew/, shell_output("#{bin}/languagetool -l en-US test.txt")
  end
end
