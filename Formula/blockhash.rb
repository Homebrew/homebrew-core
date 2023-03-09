class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/v0.3.3.tar.gz"
  sha256 "3c48af7bdb1f673b2f3c9f8c0bfa9107a7019b54ac3b4e30964bc0707debdd3a"
  license "MIT"
  revision 2
  head "https://github.com/commonsmachinery/blockhash.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2bd8504e68211016aeefb8c12c083b1a5a5589d4ac04b62145b547d4ec9dc720"
    sha256 cellar: :any,                 arm64_monterey: "3e8ac45432223a7f2a96a151b11b27b1ff30c33d7e0caba66d0d7e565dacafe0"
    sha256 cellar: :any,                 arm64_big_sur:  "96fbd6882791b9212294c0dbc4b080439fb080384bd5ee4e374c95503041a68d"
    sha256 cellar: :any,                 ventura:        "05401bb23a53dfd1ecd1519476830361c94fc70d7eab1756a6b8fec4ccd8ab3b"
    sha256 cellar: :any,                 monterey:       "717b16ad311c05d3d5d298c46dcad7b45b5fd75edfedf1c73f3c8151e04fe15a"
    sha256 cellar: :any,                 big_sur:        "65a82c820fed4896f17627820e51a4db43d7d39c97cc6e088564bf94b866cb9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "471e389ee9b722171b7f1d0dad9ce35d710d699671dc4023860a7dfdff3e7461"
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
