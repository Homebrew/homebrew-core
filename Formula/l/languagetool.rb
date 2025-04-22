class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v6.6",
      revision: "ac27103cd54291aad05c3fe2c69f0339bc8498e3"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(-branch)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fda45d3cceb453f597e4b4467ebc4fc5ce566bc7a0feeec65c1814be8150303"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e6e793ae8bf1d1299aaa17b46572b03ac51a40aac28820239ef97273d299182"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "514b18ebdf0c6b60f6be8f08eca0d2ad3d3e5d67f737f3eb55137dcd66e4073d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8953cc2fb389c688d001cabf8fd19aa09141c7ceffa3bd79a44962c48fd81d37"
    sha256 cellar: :any_skip_relocation, ventura:       "c3024db69833143ff0766e6307781111ac2a91d037fe752e2f6e477a8599822b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09e15a7fb4580e28969de66fcaa2b4c1ee46ca6a40e3e5d6b83a5d5e0c7a533e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e15642ff9620b14673b13d0665852af113da2be0d3cb60befbac09358bd3b478"
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
