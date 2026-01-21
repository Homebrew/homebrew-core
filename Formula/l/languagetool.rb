class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v6.7",
      revision: "84625f61a71ae0b54cc683e46f8e209f75169117"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(-branch)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fea33d351a9f879bc18b3482acc005a9745bea3e1e011fca5851d37fd6f83f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7b92cc5a0913b777c862b42a90b96820630157b08d6601424624d09bdaac52e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a98c2e1dfd79d4d61812874ccad3b7cd2da1ade1e91325560e13443151ac6c21"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9dcf2480437854ab2576be8f4e19ac728f5c8e048751308b01284e226e83b96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2375c3a5d2bd25954bc23b0baf74d6007f69e6ed397181d104e4327a331501c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d40b8680fd7e046f54ef4b2e79fb60cc0d7a228cb15ab2301f70016b6bc8a557"
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
