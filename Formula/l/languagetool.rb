class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v6.2",
      revision: "2fe7ae723aa7f2212dc5a71247010af981322543"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74238f26f888f1513dbd0ba07ae8b3cf439b9a37ea81e62acaba4591885373ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d07d52b4f44349f74f7cdb77964972d583e4cf7bd27baa2af6e125ca7d74aca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cd21adb77a1f11206ae2428e6d9856d5d8907fc15547b6b1b05a4e9ebbb0ec1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "501c2ed3ed592818a1359b77a8ebd382d65d4bf8983063f001174afe695b752c"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfc0614d09c75a137046b230c9ab90a16db90308f5a99b54a5be79bdc3f1e84e"
    sha256 cellar: :any_skip_relocation, ventura:        "8a468159d1b3b14432ff0cd83a46b4011e268612a45ea58ef90acc6b41e6f741"
    sha256 cellar: :any_skip_relocation, monterey:       "fa7ec4174d93c00084936ae45ca32f6a541ba224a71e22b8646a94ad3a1eb18b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0bc2df167adf00bd1e129786563a966bf51887846b74dbcbd8e5016a6088821f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ff1125eeb79f209bb4575a1edb79900b3f97925379a98055dc79488029d0cbc"
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
    run [opt_bin/"languagetool-server", "--port", "8081", "--allow-origin"]
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
