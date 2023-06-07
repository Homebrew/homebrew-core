class PdftkJava < Formula
  desc "Port of pdftk in java"
  homepage "https://gitlab.com/pdftk-java/pdftk"
  url "https://gitlab.com/pdftk-java/pdftk/-/archive/v3.3.3/pdftk-v3.3.3.tar.gz"
  sha256 "9c947de54658539e3a136e39f9c38ece1cf2893d143abb7f5bf3a2e3e005b286"
  license "GPL-2.0-or-later"
  head "https://gitlab.com/pdftk-java/pdftk.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a5857d7211fd50b381bffc97a2b986bf1b247da437f29ebd93c7f3996901e20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89c574a7f8c34385575fb89a88bb4e17c29dae1f5f4d4159c8d99a9d38e1dd9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d49f5787ea1de2dc8a3b0b5247fbe13f3afedd06300723a397034ddd55a9607b"
    sha256 cellar: :any_skip_relocation, ventura:        "99832fe1d1e78d1086d7378135379c0e999b956a91308f812854169407db811d"
    sha256 cellar: :any_skip_relocation, monterey:       "4c681bcf7c438fe4579a383ef327fa7d999bdae7a02d07610ce21b9c31e008ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "067b14996ed189e5fc3a2b648000a34376b5e49b1e523b5957f70f02e2c53fe2"
    sha256 cellar: :any_skip_relocation, catalina:       "20197d53ee7fb4954921f8a4b19617f8a506042376655a08bbbe9e04adbdddcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5324e59b0873170d230c18fedd86696fad098cd20443633c692a33d493b1c411"
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
