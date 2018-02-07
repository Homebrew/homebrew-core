class Gpatch < Formula
  desc "Apply a diff file to an original"
  homepage "https://savannah.gnu.org/projects/patch/"
  url "https://ftp.gnu.org/gnu/patch/patch-2.7.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/patch/patch-2.7.6.tar.xz"
  sha256 "ac610bda97abe0d9f6b7c963255a11dcb196c25e337c61f94e4778d632f1d8fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebce762511cd64db060d1d7fcfae5e3f05111312598b347697d116c223aa34b8" => :high_sierra
    sha256 "d7723d37ca9526120c2ab2aa57ce5d98f74f515211eb602c251d251dd59deca3" => :sierra
    sha256 "a74c4a9a33b6f33d435daaceaf86dfc829e1054d9b1df46dd6e78fa5b8a239d7" => :el_capitan
    sha256 "05701655fdfa305f92fce05758c50f51c3ff3a6a7b15a45765c3d7b9b97f38b1" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testfile = testpath/"test"
    testfile.write "homebrew\n"
    patch = <<~EOS
      1c1
      < homebrew
      ---
      > hello
    EOS
    pipe_output("#{bin}/patch #{testfile}", patch)
    assert_equal "hello", testfile.read.chomp
  end
end
