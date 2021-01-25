class Irrtoolset < Formula
  desc "Tools to work with Internet routing policies"
  homepage "https://github.com/irrtoolset/irrtoolset"
  url "https://github.com/irrtoolset/irrtoolset/archive/release-5.1.3.tar.gz"
  sha256 "a3eff14c2574f21be5b83302549d1582e509222d05f7dd8e5b68032ff6f5874a"
  license :cannot_represent
  head "https://github.com/irrtoolset/irrtoolset.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/[^"' >]*?v?(\d+(?:[._-]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "632c6b4036c71036b6b4038816dd20a3f791e9d06aab981f01429fc07bb4d3a3" => :big_sur
    sha256 "545814a389476ca20bd0419777b6d82a17a47e0e695d5bbac3ffcb8406c50c47" => :arm64_big_sur
    sha256 "958df309df54264b13dba2185761e5d4ce1397e3c6b079dbd9396e054d02d306" => :catalina
    sha256 "fd790b230ed1c3559d79c5e86080a6c5163d71817c13980a3abc904e15535d98" => :mojave
    sha256 "250f93336659350a65426d86c28053763f530b56ae9513b44f086196a91a59c3" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build # Uses newer syntax than system Bison supports
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "-iv"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/peval", "ANY"
  end
end
