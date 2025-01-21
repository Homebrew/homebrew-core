class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v6.5",
      revision: "5c6be17808cee3edc84ce53df97236521f8a8f7e"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(-branch)?$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ca43edb23f4085cf6b1efd37b7876ae4f705980b624cae9dd37ad1e88addba6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05a3e858a94d653b2b3a9a0af29de028af47231418e7daa825e5562cfe8c712f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f7cb65a2d77faa2bd87f141cb18339b88f5be78f60a469589bb53771d216d71"
    sha256 cellar: :any_skip_relocation, sonoma:        "50c37f13d72bf2777364a0149ca50a6ba41cadad28436c99d5ee48a5790cc160"
    sha256 cellar: :any_skip_relocation, ventura:       "ef00fa3c5956c4a7c62e6b6b469367c2a69fb939f7144488f6fd614b2cb7fedc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a17e9f3c0239a8178f2599053402cbefc9f1a995336db3c60d5ffb488ddaa58"
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
