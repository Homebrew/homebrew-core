class Mmv < Formula
  desc "Move, copy, append, and link multiple files"
  homepage "https://github.com/rrthomas/mmv"
  url "https://github.com/rrthomas/mmv/releases/download/v2.6/mmv-2.6.tar.gz"
  sha256 "020cb39cb177aa9e66363d73f49fe2e56aa23a3501c9cb16383f75b1ddcd4fe4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c7aa9476b38e87544ae2b503fb26b07c6797af48d6599e35fd36e36146dd703c"
    sha256 cellar: :any,                 arm64_ventura:  "f31f06317a02f971057af3ff2270d5f6bad1477fafd726e5d45bab0bf7528f30"
    sha256 cellar: :any,                 arm64_monterey: "675f1116463e152f9ebce257b12cc7751033f44699c1f9fd424c6991dc65b7e6"
    sha256 cellar: :any,                 sonoma:         "30f0afc5ae3ae60453be909614fca5744be8ca266c583be8f9210816ee5653ad"
    sha256 cellar: :any,                 ventura:        "f0ae4b832a19d6295ac1c4a06f9580386ddaec418e95c7fe87bd6eb25f38e760"
    sha256 cellar: :any,                 monterey:       "9f9c382404016cdbc966e8c4e1d191e0620b219033dcede7e88f31c2b253422c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66d09ff4bda9665a4d90eac5b93f2ad01621f3d45ecbbb6817a38c13e361de8f"
  end

  depends_on "help2man" => :build # for patch
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"

  # Backport fix for gnulib base_name().
  # TODO: Remove patch and `help2man` dependency in the next release.
  patch do
    url "https://github.com/rrthomas/mmv/commit/5a3ab0746db2f761bff332dc2411afe1f99434eb.patch?full_index=1"
    sha256 "cf9efa6f6eb175d2d71f46ab3a3da317390c82594424168f4af023abd4e9c168"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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
