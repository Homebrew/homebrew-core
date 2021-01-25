class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20201122.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20201122.tar.bz2"
  sha256 "4da0bf42c466493b44dcbd8750e7bf99c31da4c701e8be272276c16ec4caff30"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released \[stable\]/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "144e116a689c4fea40febb62cf7ed46dba36eee17e3ead766f63ecd55392bd8b" => :big_sur
    sha256 "3b32d60399915b57a64f80e020bbfdbfacce62cf9780f3799c8fc425f691dc96" => :arm64_big_sur
    sha256 "dc76d7573944f64ce047c3025320a12aef3c744d019449d62040d7121a476d23" => :catalina
    sha256 "32f6187f65e0b9b6c706a5eb6c6e24c8097a3701f5d8f7cc885bf0be82478cf0" => :mojave
  end

  conflicts_with "moreutils", because: "both install a `parallel` executable"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
