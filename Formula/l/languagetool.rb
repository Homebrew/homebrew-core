class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v6.3-branch",
      revision: "fb238b2a32bc72714632a399c9b47abbe9f1c0c1"
  version "6.3"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(-branch)?$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "163baadef2742f9834b15361d6209f259dce2482e8f4a0b1807bc36428da7940"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8bc52897bdd1d2444ae039df4d0f5359dcf84b91c47c10036f27b8e6733304c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "671b706c4d3c2e9375bf0b9333961c60ed2e063c76acec6853040273139ed20d"
    sha256 cellar: :any_skip_relocation, sonoma:         "d05f3fd432d7a7870c2099d55a8cd5526c43c8404e77fab0678d4a7cf81dfd52"
    sha256 cellar: :any_skip_relocation, ventura:        "37871ac7ea214080971f665b44ec893872136464e48b4edfe5794c9992eca18e"
    sha256 cellar: :any_skip_relocation, monterey:       "00ffc52cf265b2aea5b46dee28461eecb945b4f187d71ac800f01f11828039e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c9966fabe2e8f8462b77f6bc681b9a40c6fe287030842c8f42b313ef62feeda"
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
