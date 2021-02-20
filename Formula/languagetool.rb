class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v5.2.3",
      revision: "fb961c9735cb632b82bd47099fc04f42981d56e4"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "9753ae0ec75627733703df26db05d5e54f7c3faa0b612c191f8de2c116c1a9e0"
    sha256 cellar: :any_skip_relocation, catalina: "4948aa9547e2562282fa6b0ddc12c27093bb09ff124bd3fe2190301956d3a191"
    sha256 cellar: :any_skip_relocation, mojave:   "d5dcd3a16324dc4fe9c0684530e687cd792ebecccd755de53b73b056dbdffd72"
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
    assert_match "Homebrew", shell_output("#{bin}/languagetool -l en-US test.txt")
  end
end
