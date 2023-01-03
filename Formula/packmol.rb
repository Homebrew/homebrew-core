class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/v20.12.0.tar.gz"
  sha256 "9c8a97f273ce6c6932b209a6c4e01653d02e1194bcb541d513f14b33f4bdab80"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1f3cb8f652817ff023117656ae4ffa5ed9429e1aa6f5e9c74f0eecb2e5388350"
    sha256 cellar: :any,                 arm64_monterey: "e3f60b53ae9a41f62b28594c967b8612f3b383e43397f69b74778dcf091de6b5"
    sha256 cellar: :any,                 arm64_big_sur:  "5f11f9cd2ade93a0224266cdcca547e5e44111c708d7e4f6484fbf7e483b373d"
    sha256                               ventura:        "20938c6219173b29f755897d99996dc7e6f8f49e5b16d2e8bc60586255e587d4"
    sha256                               monterey:       "1e9a0857700f0033c2da0f3314b28003cdf072ff9cc97008e296b7f9e39e0aff"
    sha256                               big_sur:        "150d8fd325e8092381f5635ac4dc3ff31b870319988a1553620f565d497e5076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be20da000a29fd155a2b422623c2a42a2a73e92e0fccae62a6e152ae5a930942"
  end

  depends_on "gcc" # for gfortran

  resource "examples" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  def install
    system "./configure"
    system "make"
    bin.install("packmol")
    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("examples")
  end

  test do
    cp Dir["#{pkgshare}/examples/*"], testpath
    system bin/"packmol < interface.inp"
  end
end
