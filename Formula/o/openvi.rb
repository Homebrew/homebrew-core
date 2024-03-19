class Openvi < Formula
  desc "Portable OpenBSD vi for UNIX systems"
  homepage "https://github.com/johnsonjh/OpenVi#readme"
  url "https://github.com/johnsonjh/OpenVi/archive/refs/tags/7.4.27.tar.gz"
  sha256 "7a40c9388c4f34d039a1fcac0ce24cc4ed6cb892d016fe26c0aaa6f42293ad47"
  license "BSD-3-Clause"
  head "https://github.com/johnsonjh/OpenVi.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d626305e066850196c3c153840f8ad7d938098225abbf99345cc5368ea66188c"
    sha256 cellar: :any,                 arm64_ventura:  "73ff3682a17795dc2c95d9b32d921ab8724f4534298fa00e95973dc5cf2063ff"
    sha256 cellar: :any,                 arm64_monterey: "ffc56a096e067d8947a225acbe78b52ab8f34504a19b6e9f81920054f790ec83"
    sha256 cellar: :any,                 sonoma:         "d1dc2056d9472a229cdb9acfdd9afd6afbf866eb5e13360d1eef5a53d6ee340d"
    sha256 cellar: :any,                 ventura:        "394a1cf3dd57829001a947522857ee6553541446e588658addeaad65240b228c"
    sha256 cellar: :any,                 monterey:       "06583a5f3ac623e53acc6141466b4ea3258e589b72e0b21522003cee470a62c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "693dbc0eb5a41e6bfce9f829700d330f8ef300678a5b2e3acd033d876ca8f66b"
  end

  depends_on "ncurses" # https://github.com/johnsonjh/OpenVi/issues/32

  def install
    system "make", "install", "CHOWN=true", "LTO=1", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test").write("This is toto!\n")
    pipe_output("#{bin}/ovi -e test", "%s/toto/tutu/g\nwq\n")
    assert_equal "This is tutu!\n", File.read("test")
  end
end
