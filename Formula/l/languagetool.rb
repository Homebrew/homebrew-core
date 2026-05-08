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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6f1f9c9689a9c44484d7bdaeebec9bd9c5ade21f2d0a31bc229cf8862564a0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d8adb5386f04909c226e5655817e944b05c888608e032ded305c3f99618b8c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e22c41d9a141788580600f4e5296c9ea75e41f24bb55f3501c3a330fd7e07ae2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f7f36ab6f9345d9c0b76e550fdf36b2d3162ebcea8ff93f1f189d4b3142db75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0c7bc609cc7f0f1a820a3726de8b5c768e44035834209ab3d3d3d30e755a1a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62426512fa454101a223b9a178e4983f43b48aed3782352c268b04f4e9859273"
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
