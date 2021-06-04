class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "46913b17c85711213251948342d0f4d0fec7dc98dd11c1f24eedb0409338e273"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "05d9b0a276072071f22ea6dd9fd1b3b53b19dff3d94885331e8c85019ff7d12a"
    sha256 cellar: :any_skip_relocation, big_sur:       "208b95b7de1a9700dae6121fccee564a10080e18be39e4d690cfc04137efc9c7"
    sha256 cellar: :any_skip_relocation, catalina:      "0d8918ccdeccdccd33c8d3712b67afd9355ac807b87b7e34308b169618dc993e"
    sha256 cellar: :any_skip_relocation, mojave:        "e142eb441e6c5989155f7c57f257a2d02d42c764fff7974f21b3e82dcc00446a"
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
