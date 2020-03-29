class OneMl < Formula
  desc "Reboot of ML, unifying its core and (now first-class) module layers"
  homepage "https://www.mpi-sws.org/~rossberg/1ml/"
  url "https://www.mpi-sws.org/~rossberg/1ml/1ml-0.1.zip"
  sha256 "64c40c497f48355811fc198a2f515d46c1bb5031957b87f6a297822b07bb9c9a"
  revision 2

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "309111ca64b6c6fa02f1a93dcdc83858d74bc4d7e6a1bcb898443b72e2fa62fc" => :catalina
    sha256 "ddd62944bea4f0182b771d405d2255c1d5cdd9e217a2bc00891018de9458b7c2" => :mojave
    sha256 "d377a804f2f05d9f48869a6822bb42070be94b225d1d24ee0f4a3e23019532c8" => :high_sierra
  end

  depends_on "ocaml" => :build

  # OCaml 4.06 and later compatibility
  patch do
    url "https://github.com/rossberg/1ml/commit/f99c0b3497c1f18c950dfb2ae3989573f90eaafd.patch?full_index=1"
    sha256 "778c9635f170a29fa6a53358e65fe85f32320eb678683ddd23e0e2c6139e7a6e"
  end

  def install
    system "make"
    bin.install "1ml"
    (pkgshare/"stdlib").install Dir.glob("*.1ml")
    doc.install "README.txt"
  end

  test do
    system "#{bin}/1ml", "#{pkgshare}/stdlib/prelude.1ml", "#{pkgshare}/stdlib/paper.1ml"
  end
end
