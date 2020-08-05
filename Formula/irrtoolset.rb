class Irrtoolset < Formula
  desc "Tools to work with Internet routing policies"
  homepage "https://github.com/irrtoolset/irrtoolset"
  url "https://github.com/irrtoolset/irrtoolset/archive/release-5.1.3.tar.gz"
  sha256 "a3eff14c2574f21be5b83302549d1582e509222d05f7dd8e5b68032ff6f5874a"
  head "https://github.com/irrtoolset/irrtoolset.git"

  bottle do
    cellar :any_skip_relocation
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
