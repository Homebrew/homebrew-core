class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.3.0/pdftk-v3.3.0.tar.gz"
  sha256 "f8218de3bed18ca0d22337d1f3410b2a005794f8bb3729c8da20f3a49954c9ba"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/pdftk-java/pdftk.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf6ca17dbf4888a97fd58f9e83299e7ea0a6381eabdad9950f7b3b8a30b13963"
    sha256 cellar: :any_skip_relocation, big_sur:       "e0993aece6b68cf62e18bf374ee8dd8e099050cfb5e2ef603fe3f02e6b000f20"
    sha256 cellar: :any_skip_relocation, catalina:      "a8b1d52520c0cb5dcc146dc08edab5cb74a1452b7e6099b4fa002bd3e10635f6"
    sha256 cellar: :any_skip_relocation, mojave:        "08386bfdf5b33f25585bb35a6196b1daab912394c55f5844c8385d82f5c60512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57ef21e942c613817859bd28cf0a59c5af8e55ccf8fef617d5f619c938d622b0"
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
