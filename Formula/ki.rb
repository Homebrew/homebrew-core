class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "ed497ae76b60e59756f3971e2ab7ccf5cdb72774ece38748385bc4d1b52d4272"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "44a0b176b99d690c3612d10dd7e74e89681ed49ebe21a59d02b0f2385d9fb099"
    sha256 cellar: :any_skip_relocation, big_sur:       "e274b42061c74931ef8da5e556a7d7ef7ffeed29a73667f3ace4859a6a6329f2"
    sha256 cellar: :any_skip_relocation, catalina:      "9f8b79b2f38b559e36a8a5f44e658a7ae85d5e2d3bb8c9cd4691185f41446299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "accc98d52e3ec26c07b35ac64e381b0d27c8639d5c32a76ccea4a8093635a28a"
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
