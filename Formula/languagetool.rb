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
    sha256 "6e0b47919b400614b541ced972d8513f81bdacad7bce2077cd3ca8d72c2026c6" => :big_sur
    sha256 "247283b436a70bb8b5b3ecf43becaa3b986d260ff68d602417ed39e441befe5e" => :catalina
    sha256 "c25896d28e5b4484317fb881478a67122cb847e53dd3f78b99e66790a5d54790" => :mojave
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
