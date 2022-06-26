class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v5.7",
      revision: "35d0d40e1e795919473563d6102df5b464ba7d29"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76b6e84cbcaf6e3cff9919db0bc2c878edcedf443c121440a0a42bd4e6628e44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52da62ec625153b1f785103f1a3e3086f3925123a0a3f34f3203b6d2fa7707f2"
    sha256 cellar: :any_skip_relocation, monterey:       "721a4898a93243d3ea9c3ca20bc5901b77e914d4bc98d3c4b943212adf1986b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "03b221baba14ee0e13a6d57d1ffda7b20a657c425fd488309b0e16fec2069cac"
    sha256 cellar: :any_skip_relocation, catalina:       "42bff670a922542770ea16acd7bc30e84e61b3e7614c4e895eec02d823b7ebfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd8d29c7aac9805ccefc9ee6810197a5350bb6c1ebb701bfc7fd71c9333e7576"
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
    run [bin/"languagetool-server", "--port", "8081", "--allow-origin"]
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
