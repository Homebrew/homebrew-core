class Languagetool < Formula
  desc "Style and grammar checker"
  homepage "https://www.languagetool.org/"
  url "https://github.com/languagetool-org/languagetool.git",
      tag:      "v6.1",
      revision: "a6449c3b940c4c8d869cc3212ee7cda9da83dd87"
  license "LGPL-2.1-or-later"
  head "https://github.com/languagetool-org/languagetool.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bab759e7b1e1509d6692e707f84de39c4e5cac69e8522ef082d4a39c41b08209"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2425a86ddd0d84b4e93aa80b01a309dac298bce3b113d694247ced9aeb6f0990"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61c9951a86f989f968cfa3474b1482f204d6a998f32255424735a454433f86bc"
    sha256 cellar: :any_skip_relocation, ventura:        "149c5997d45de0316974f96858a35e4b91e325ff61a1799feb70d7c19ea8d7ed"
    sha256 cellar: :any_skip_relocation, monterey:       "970fcb23d317984e58afb673eb3193c6df5fbad4a1e4ba98fb25d043b6415bf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "91b2edfba72b7e182a8c7cdbd5f07dff0faf37d0fda46cc96780f52d53296c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dad7511ae7685d600e96c19fd0c2a2f42deefb982bb9423055e4c7a3e1e44cbb"
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
