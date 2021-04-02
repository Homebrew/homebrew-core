class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "46913b17c85711213251948342d0f4d0fec7dc98dd11c1f24eedb0409338e273"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    system "mvn", "-DskipTests", "package"
    libexec.install "lib/ki-shell.jar"
    bin.write_jar_script libexec/"ki-shell.jar", "ki"
  end

  test do
    output = pipe_output(bin/"ki", ":q")
    assert_match "ki-shell", output
    assert_match "Bye!", output
  end
end
