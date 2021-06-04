class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.2.2/pdftk-v3.2.2.tar.gz"
  sha256 "b284e413dd43fe440152360eccbc5cb9ffd8978be8313ffc060bfebb74d14bf1"
  license "GPL-2.0-or-later"
  revision 2
  head "https://gitlab.com/pdftk-java/pdftk.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4cdfaefc63a4caddee15fc23058cfb7be7c159a6b8ce980a87e6dde37e3966b9"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1e9cf81c2a4f3dc4a8a01b9321fbc3906f2fce81dddbcc3943efc8d556d9029"
    sha256 cellar: :any_skip_relocation, catalina:      "97c310d403777275c885d7168bd5918ca1296fc97f03bd85a7a07728c8ed535c"
    sha256 cellar: :any_skip_relocation, mojave:        "c5eb235c5f13d5c169375c1bc80edbbd43ee475fd490e2f3ae65fca1c5689da4"
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
