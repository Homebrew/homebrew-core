class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.3.1/pdftk-v3.3.1.tar.gz"
  sha256 "4a97856c8aadfa182e480d2e717842e6cbed43829cd917c9f9dd2d15b57d3d2d"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/pdftk-java/pdftk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b39414ca757497c2ecf367dba6d7d5945bff661ce0b531a3ada5b592e20620f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "c2d6700a275ad2086d8ca1cfe61aaba8c902cfeb13f23ef9b6338ad240265e88"
    sha256 cellar: :any_skip_relocation, catalina:      "eb7cd355d05036bc3eeea59ba6eecac89681d573a8235c11f738e55d14fe28aa"
    sha256 cellar: :any_skip_relocation, mojave:        "8018f1c426cc986117c779dd18bd8ce8741832b2578579bf4a5d28b5f01a7475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e57b733da09e724c38bc5af7bb5aa9b565e32bfe004174beb0d99ef8e89a37"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@11"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk", java_version: "11"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
