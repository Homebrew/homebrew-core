class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "46404602ca69c18a777ed2c88de5c5eec7e43d4cc1e77a4b44e413701bd327a0"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e3e0dbec5307e74aca8119b3b683fefaa9d8bfb1e987354a63bd09a410bd9256"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e3e0dbec5307e74aca8119b3b683fefaa9d8bfb1e987354a63bd09a410bd9256"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e3e0dbec5307e74aca8119b3b683fefaa9d8bfb1e987354a63bd09a410bd9256"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "761bf632ea5e157351729a1e137da1333e4f712a6143ec4581d116eb9e1ccf18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "761bf632ea5e157351729a1e137da1333e4f712a6143ec4581d116eb9e1ccf18"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  allow_network_access! :build

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home

    system "mvn", "-DskipTests", "package"
    libexec.install "lib/ki-shell.jar", "lib/ki-completion-plugin.jar"
    bin.write_jar_script libexec/"ki-shell.jar", "ki"
  end

  test do
    output = pipe_output(bin/"ki", ":q")
    assert_match "ki-shell", output
    assert_match "Bye!", output
  end
end
