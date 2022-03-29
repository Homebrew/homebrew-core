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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1c8739494cda61d938cf4302d222f0854e8691a892c0537eb450e88101eee2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f45b959adfa17dadeaf94774ccab302dc8d57d4e96b2f5170e345712d4912bf"
    sha256 cellar: :any_skip_relocation, monterey:       "2fb5d941ec7f34f5be3b078c633c7075b486a4402ec5633339a36fd441bd517b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad70857fd5e0bd6a1ceb6779286fb25ee4d7c1a1cc9b964ef8ef582aad4c473d"
    sha256 cellar: :any_skip_relocation, catalina:       "29ff4bd293e7ac389c1c0db6ebe76c87719a9426271d9b4ec365d022e5fcf5b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da21638d0ce92a4fe5c72b4f2e00ff92e33703212ec18c4c76468a0921b9d8d"
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
