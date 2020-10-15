class Parallel < Formula
  desc "Shell command parallelization utility"
  homepage "https://savannah.gnu.org/projects/parallel/"
  # Version 20200822 is considered beta software on macOS
  # See https://savannah.gnu.org/forum/forum.php?forum_id=9800
  url "https://ftp.gnu.org/gnu/parallel/parallel-20200722.tar.bz2"
  mirror "https://ftpmirror.gnu.org/parallel/parallel-20200722.tar.bz2"
  sha256 "4801d44f2f71eed26386a0623a6fb3cadd7fa7ec2b5a7bbc5b7b52e2a0450d6f"
  license "GPL-3.0-or-later"
  version_scheme 1
  head "https://git.savannah.gnu.org/git/parallel.git"

  livecheck do
    url :homepage
    regex(/GNU Parallel v?(\d{6,8}).*? released \[stable\]/i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "a7cb843b66ce52d0782f612edda3833718be72adc165776079256648788306c1" => :catalina
    sha256 "5a1f7e2fb880f35fc891fcce8a0e1c2c0c65ccfda9e15f3b47d830898b897bbd" => :mojave
    sha256 "45342decbb00fbe375e0fced35278827a485e91c2af8de29a5f2eed4697404ab" => :high_sierra
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
