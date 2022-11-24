class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/v0.3.2.tar.gz"
  sha256 "add1e27e43b35dde56e44bc6d1f0556facf4a18a0f9072df04d4134d8f517365"
  license "MIT"
  head "https://github.com/commonsmachinery/blockhash.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "67432abfd6ac194008d2166e17b9a8f6f079c1335186724d3f4c18c0df8c23bf"
    sha256 cellar: :any,                 arm64_monterey: "c371333e6fb3b87bb8705b59656bee1f0273b908e9703c273491ca1e8cde6321"
    sha256 cellar: :any,                 arm64_big_sur:  "ea24e2ec0238503bfd4d4bb60aad606be7721acec5320db0dca8518cbd017e2b"
    sha256 cellar: :any,                 ventura:        "72ed4ad9d257ae3db75ebfa5599ed985e3a8c8b6093d3b1194e8ac54c029da19"
    sha256 cellar: :any,                 monterey:       "3f2fed32a9e23dfe2c96fbb1659c4096626b8af48c42c6f1cd9695f6be79d863"
    sha256 cellar: :any,                 big_sur:        "f3d00d88a90889cd500ecc7c335ccb202f98d067f4224df1d940289d49caaf6c"
    sha256 cellar: :any,                 catalina:       "cab37517dd31e66ef9092d2f390aadadeb84a2b21bea2e1c3bf1c3410f8f6fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef68b2a762b5c5bd42e28103e78b9782268d9c756beff3d3934be996a1500711"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "imagemagick"

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
    sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
  end

  def install
    python3 = "python3.10"
    system python3, "./waf", "configure", "--prefix=#{prefix}"
    # pkg-config adds -fopenmp flag during configuring
    # This fails the build on system clang, and OpenMP is not used in blockhash
    inreplace "build/c4che/_cache.py", "-fopenmp", ""
    system python3, "./waf"
    system python3, "./waf", "install"
  end

  test do
    resource("homebrew-testdata").stage testpath
    hash = "00007ff07ff07fe07fe67ff07560600077fe701e7f5e000079fd40410001ffff"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end
