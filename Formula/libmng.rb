class Libmng < Formula
  desc "MNG/JNG reference library"
  homepage "https://libmng.com/"
  url "https://downloads.sourceforge.net/project/libmng/libmng-devel/2.0.3/libmng-2.0.3.tar.gz"
  sha256 "cf112a1fb02f5b1c0fce5cab11ea8243852c139e669c44014125874b14b7dfaa"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c446fd993909b3334b8df2eaacf0af44be6da33c03899c85bc966b8659858648"
    sha256 cellar: :any,                 arm64_big_sur:  "10950a560440734b94a43fffd1988e483c2ff6530b3cf76825c80e9453069831"
    sha256 cellar: :any,                 monterey:       "f4918c5d36c45d1052351dba94990fd7eb1a3d47123705685add8bec7720c683"
    sha256 cellar: :any,                 big_sur:        "ae1a19ad2cb9cad4f252aafd63c43d8c44b68175ddace7b0b6369d8541514bce"
    sha256 cellar: :any,                 catalina:       "0102c3da599178979dba5b225b6fd15cf7896cd64cb41bd548c2cc2487425db2"
    sha256 cellar: :any,                 mojave:         "e1468ebcdd4fdbb47edf1e0c053206bbaa8792f0ef73fb297cc96f21533965f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76a41e2666007dabb0bce0da17d0a55ca7694168e74f31ec6136cb9632642eea"
  end

  depends_on "jpeg"
  depends_on "little-cms2"

  uses_from_macos "zlib"

  resource "sample" do
    url "https://telparia.com/fileFormatSamples/image/mng/abydos.mng"
    sha256 "4819310da1bbee591957185f55983798a0f8631c32c72b6029213c67071caf8d"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"

    # Keep an example for test purposes, but fix header location to use system-level includes
    inreplace "contrib/gcc/mngtree/mngtree.c", "\"../../../libmng.h\"", "<libmng.h>"
    pkgshare.install "contrib/gcc/mngtree/mngtree.c"
  end

  test do
    system ENV.cc, pkgshare/"mngtree.c", "-DMNG_USE_SO",
           "-I#{include}", "-L#{lib}", "-lmng", "-o", "mngtree"

    resource("sample").stage do
      output = shell_output("#{testpath}/mngtree abydos.mng")
      assert_match "Starting dump of abydos.mng.", output
      assert_match "Done.", output
    end
  end
end
