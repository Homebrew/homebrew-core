class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/v0.3.3.tar.gz"
  sha256 "3c48af7bdb1f673b2f3c9f8c0bfa9107a7019b54ac3b4e30964bc0707debdd3a"
  license "MIT"
  revision 1
  head "https://github.com/commonsmachinery/blockhash.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c249346671fb6df5de0d17abf1f7f6897cda778530aff73c3eb359592f879da1"
    sha256 cellar: :any,                 arm64_monterey: "f69f63dabda4d48b8aef51968228268358ca91b60dcd1318bc040745c2458770"
    sha256 cellar: :any,                 arm64_big_sur:  "e1c024ab5f658f47129674a1ad716c402e35272f4a43d14fc0a33c03793e0a6a"
    sha256 cellar: :any,                 ventura:        "b214da364b5a6454eae3774a4232deb46337d507bafc7b18d8fea823d2ba8669"
    sha256 cellar: :any,                 monterey:       "9f55a2219a4f75779407f478f39eddc926f23ba95fb2b8c910fe8d56e9086e01"
    sha256 cellar: :any,                 big_sur:        "d2369a6bdd8bc7045dea6bda77939b3686150b48ea0e3450f853f165b043e1b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "716cebef5a17982594ec464adf4753f9a00c78c24880f617037c1d2cae74021b"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "imagemagick"

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
    sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
  end

  def install
    python3 = "python3.11"
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
