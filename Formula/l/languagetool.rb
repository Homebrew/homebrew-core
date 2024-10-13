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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97c26d8e5411371399984b4885cb6ffd4eccf8eae64f3ea7b362c34d21b22b6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0869f074714fb4c31fa49c57af0dc47609176b9f00d6258239a31502e2ec0c37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9389d2adcd583ec4e1885b48d2e7325c50ac70a9cc292e5dbc1403ef34ca4e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0271c888c528c6392a9f96798dc665bc98ab84c6ecf2cb28ec0a03862979874"
    sha256 cellar: :any_skip_relocation, ventura:       "ae84393965f3efa95ce9527168dd8e89b46187e0a71960ab93d38a15827afc1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3231ad327caaf0cfc04a8fc015dcef3acc2994ba5706fac55a6b7c4da6b53ede"
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
