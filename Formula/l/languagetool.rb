class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v6.8",
      revision: "e807fcde6a6506191e1470744d2345da28c26be6"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(-branch)?$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09bf7415e9ada06b02609681d2d8e1ac5a16cfddebaee979fd8a3eff45022cc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68783053c71a4a16dfc6a7fc977340ad4feaedbdfb92e606830003548ff00249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b3e15a9e42fbab0702c40b20cd350e4fa8d1429b044b4763a918c676b88f6fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d74c89ed15f1bcd9b6b5cfdda2b880ea43d2be6a2c7fc4f28a1744bd5ee00de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c026514d9e1f0cfc8e413f6806a7b1251e9a0ecbdc51b43f57b0b281c41f29cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "683743c0118447b8eef14156e601d585cca8e907f99b92ddc2a63db79e2f13b8"
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
    (bin/"languagetool-server").write <<~BASH
      #!/bin/bash
      export JAVA_HOME="#{Language::Java.overridable_java_home_env(java_version)[:JAVA_HOME]}"
      exec "${JAVA_HOME}/bin/java" -cp "#{libexec}/languagetool-server.jar" org.languagetool.server.HTTPServer "$@"
    BASH

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
