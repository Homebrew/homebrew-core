class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "cb90a199f8e1742d7b4cd304d06108efa5d2c30ff7330d6e66ed0e9eed7a9505"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4a1ee5e5bb0bf0b056a5866d0929205dc18d527eda8440a62472ac754bb37224"
    sha256 cellar: :any_skip_relocation, big_sur:       "5aabd7a1c7d6950f3f83a2a4b27f93cdc1c280e00934270b58a72a2efc337eae"
    sha256 cellar: :any_skip_relocation, catalina:      "e02c9d31581795565ef161220c8882a2cf154393ad0ed235f89ed9582fb123cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7c09fe8b6fdf4bf061d72b307b391ee0306f53af63a232a2048cb51a70257e4"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system "mvn", "-DskipTests", "package"
    libexec.install "lib/ki-shell.jar"
    bin.write_jar_script libexec/"ki-shell.jar", "ki", java_version: "11"
  end

  test do
    output = pipe_output(bin/"ki", ":q")
    assert_match "ki-shell", output
    assert_match "Bye!", output
  end
end
