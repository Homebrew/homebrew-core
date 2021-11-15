class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.3.1/pdftk-v3.3.1.tar.gz"
  sha256 "4a97856c8aadfa182e480d2e717842e6cbed43829cd917c9f9dd2d15b57d3d2d"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.com/pdftk-java/pdftk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "697142c434ed6b00925ba13c845f5a91942ef9509e63393b1ca12fd7b3acc9b2"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb0b076125b9b7023eef4aa646b14bc087476e3ea8950e93e9c4aa5b68265dd7"
    sha256 cellar: :any_skip_relocation, catalina:      "c1719607f7e628fb26215b53c2e4b10dab3f20bf6533476d0825dafdc604c3bc"
    sha256 cellar: :any_skip_relocation, mojave:        "603bf4ee89edf29dd9e8c272b719ea6bb42e58a14b5eb59569ff74d1d6d8e207"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4609e765fe7a9a7737f29262b30dc5b3ef7db5269857ff36f28702807e0bcfb2"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@11"

  def install
    system "gradle", "shadowJar", "--no-daemon"
    libexec.install "build/libs/pdftk-all.jar"
    bin.write_jar_script libexec/"pdftk-all.jar", "pdftk", java_version: "11"
    man1.install "pdftk.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output_path = testpath/"output.pdf"
    system bin/"pdftk", pdf, pdf, "cat", "output", output_path
    assert output_path.read.start_with?("%PDF")
  end
end
