class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git", tag: "v5.1.3", revision: "9ef0a18d77cfb39143cf99619e26d374ede7fb7b"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/languagetool-org/languagetool.git"

  livecheck do
    url :head
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "abc34aa15417a0b27c29d991e467d2bf039e856755c771026ddc25aa28768055" => :catalina
    sha256 "a8e667a790fb2c339006f0ab9e191dcf7f61929e2936bf8a17ef0928d797b4ea" => :mojave
    sha256 "0574176bcd107ae1933decbdabc6d71d1060c391bd7740436883b96a8059eb02" => :high_sierra
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
