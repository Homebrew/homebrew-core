class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftp.gnu.org/gnu/parallel/parallel-20201022.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20201022.tar.bz2"
  sha256 "35fe29864af62b5331affb84d8be683d52a7bf5fd3532fe0b6a4207a481af061"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released \[stable\]/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ff1a330be51f19aaac564e19993cb0577da67c83f6218b02f94ea3d9a110ceb3" => :catalina
    sha256 "11d90c8fbbc68580b6e0aa738b29b79eaa5fb515ab5c217e55552bc62b242d5c" => :mojave
    sha256 "fa0ef5033ed82ff4639af5d4ea53ca8036f3e28d9c4aad280b645a273bda78f1" => :high_sierra
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
