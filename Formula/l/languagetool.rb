class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v6.6",
      revision: "f13e71a7fe85a122290826fd691d267d64e97c33"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(-branch)?$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227a97bd8f1d5d0758c39333e83b6592d7fd0e32ecf16c12ce672153ec61ae46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fab8a1497d501d34cbe092a4f654fc48f723c7987e98de03668a592f85fffaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f834002277b32d58c770d84ff8b8cb79b375f7556baea3c22d429b83e453401"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f926f87d50925e4d80b5e76f7c5949bb7fe394f94877d3256240291364d543d"
    sha256 cellar: :any_skip_relocation, ventura:       "3ec986752ccb42e85971b148a753f7e65ee62eeb89252191837145daf6f8ce37"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a63b1434847e5fdcd826799840eac2d22bba23ea4b2aa8f5e03bb1be59a916f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90f387a97cc6c4814c309a52f251ceb576225d6fe16734ad44f56f7180761a1d"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  def install
    java_version = "17"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)
    system "mvn", "clean", "package", "-DskipTests"

    # We need to strip one path level from the distribution zipball,
    # so extract it into a temporary directory then install it.
    mktemp "zip" do
      system "unzip", Dir["#{buildpath}/languagetool-standalone/target/*.zip"].first, "-d", "."
      libexec.install Dir["*/*"]
    end

    bin.write_jar_script(libexec/"languagetool-commandline.jar", "languagetool", java_version:)
    bin.write_jar_script(libexec/"languagetool.jar", "languagetool-gui", java_version:)
    (bin/"languagetool-server").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="#{Language::Java.overridable_java_home_env(java_version)[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" -cp "#{libexec}/languagetool-server.jar" org.languagetool.server.HTTPServer "$@"
    EOS

    touch buildpath/"server.properties"
    pkgetc.install "server.properties"
  end

  def post_install
    (var/"log/languagetool").mkpath
  end

  service do
    run [opt_bin/"languagetool-server", "--config", etc/"languagetool/server.properties", "--port", "8081",
         "--allow-origin"]
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
