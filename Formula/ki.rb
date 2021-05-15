class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "46913b17c85711213251948342d0f4d0fec7dc98dd11c1f24eedb0409338e273"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a6343063d109cbf342ccb89419286d3e83105996d718d818be06cc41874b8e80"
    sha256 cellar: :any_skip_relocation, big_sur:       "1c10b8affdb159a68b64768036d7a7b251cc10719b4f98b1d908d1c00a367ef3"
    sha256 cellar: :any_skip_relocation, catalina:      "4b199ebd023f4f8f227f6e508f344bf0c53f4451717dae335e55400232044e2c"
    sha256 cellar: :any_skip_relocation, mojave:        "54967e266b370fc3d1eab2a56325db4500a2e310fa00eb34417c23860d26eb06"
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
