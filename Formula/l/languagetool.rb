class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v6.4",
      revision: "0e9362bdd0dfded52f11bd1333cead51d049d71f"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(-branch)?$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26fb92b5cd79ba7cb53e53fbd4cc58842638d44ac94959f6e18ab8b27784d14c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef314170d34b0e2a8a9234c877ade3ec13552da14bdf4056fabed09f39a50b77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6df7eabf36e2d8de3984b8be116209b5956d5acec9bea8f0c4c00967143204c5"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5ac1f6d2380b275c35faee6ce17899220661c8f33d446b6642522944bcf1334"
    sha256 cellar: :any_skip_relocation, ventura:        "9189140e26e03aee2972c798267319598ba4b18ddb220afc2165bc453538357d"
    sha256 cellar: :any_skip_relocation, monterey:       "617c20a2e5c94b0eb8d6f8106782318b6e37229fb5d7553037ddadac987d8ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13de29aa665fe0ece1af8ef700b2d158bc04439fa37e8986b4b82ad079a41fc5"
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
