class OneMl < Formula
  desc "Reboot of ML, unifying its core and (now first-class) module layers"
  homepage "https://people.mpi-sws.org/~rossberg/1ml/"
  url "https://people.mpi-sws.org/~rossberg/1ml/1ml-0.1.zip"
  sha256 "64c40c497f48355811fc198a2f515d46c1bb5031957b87f6a297822b07bb9c9a"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?1ml[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "368f5935a15438e05e77d4293c36e2922b552b890e16819848de0c0d67a63856"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f160c6c8c3c5f2bdaa67f5b6a478718d622defd245d2c2cc292f3bb9eb7c9de1"
    sha256 cellar: :any_skip_relocation, monterey:       "e7bfeee525cb93ea0115f8d68e3f2efb1392394bf0811869d1db7f54bc9bd783"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc39abea38a72c696d33bc62d13f21c2ed32cd45ee8a6ab66f78d2a9b654961e"
    sha256 cellar: :any_skip_relocation, catalina:       "309111ca64b6c6fa02f1a93dcdc83858d74bc4d7e6a1bcb898443b72e2fa62fc"
    sha256 cellar: :any_skip_relocation, mojave:         "ddd62944bea4f0182b771d405d2255c1d5cdd9e217a2bc00891018de9458b7c2"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d377a804f2f05d9f48869a6822bb42070be94b225d1d24ee0f4a3e23019532c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "924420564fa34eddc5c750e2d12b0cddb9326d7d2001eeeebfd70d6ca32ad63f"
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
