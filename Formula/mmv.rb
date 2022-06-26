class Mmv < Formula
  desc "Move, copy, append, and link multiple files"
  homepage "https://github.com/rrthomas/mmv"
  url "https://github.com/rrthomas/mmv/releases/download/v2.3/mmv-2.3.tar.gz"
  sha256 "bb5bd39e4df944143acefb5bf1290929c0c0268154da3345994059e6f9ac503a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3a1bf74f003cdae6fc986c25a956c45be2bb28ca46ec508305204ab14ebcf1fb"
    sha256 cellar: :any,                 arm64_big_sur:  "6f86d48ad49c5e7f3bb4e8e0487265aa0ec676a47fdd57f8894a80d8a2357aa8"
    sha256 cellar: :any,                 monterey:       "a4e282c205dfa25aa2195d4535be737130e7ee3756321440c5bf70e555a4c00f"
    sha256 cellar: :any,                 big_sur:        "60ad4a7c887f16254cf20ea00c55ffcd6447e17f58934e18cf449fdb4fe801dd"
    sha256 cellar: :any,                 catalina:       "3a975dc6f5378ae7cf1f5fa50d7adfa964a54c0665286ea6de29f16e3f7701a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "406301dd22c9b3a3aff8509419420f70280a5be2b9c51c1e1a752fda643e87b1"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"a").write "1"
    (testpath/"b").write "2"

    assert_match "a -> b : old b would have to be deleted", shell_output("#{bin}/mmv -p a b 2>&1", 1)
    assert_predicate testpath/"a", :exist?
    assert_match "a -> b (*) : done", shell_output("#{bin}/mmv -d -v a b")
    refute_predicate testpath/"a", :exist?
    assert_equal "1", (testpath/"b").read

    assert_match "b -> c : done", shell_output("#{bin}/mmv -s -v b c")
    assert_predicate testpath/"b", :exist?
    assert_predicate testpath/"c", :symlink?
    assert_equal "1", (testpath/"c").read
  end
end
