class Libmng < Formula
  desc "MNG/JNG reference library"
  # Use Homebrew curl to work around audit failure from TLS 1.3-only homepage.
  # TODO: The `using: :homebrew_curl` can be removed once default curl on all
  # CI runners support TLS 1.3 or if there is a way to skip homepage audit in CI.
  homepage "https://libmng.com/"
  url "https://downloads.sourceforge.net/project/libmng/libmng-devel/2.0.3/libmng-2.0.3.tar.gz", using: :homebrew_curl
  sha256 "cf112a1fb02f5b1c0fce5cab11ea8243852c139e669c44014125874b14b7dfaa"
  license "Zlib"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5f011ac978c211c58be07ecb0a9cf4f5a563ebde089a40deff5116e0ad7ee86b"
    sha256 cellar: :any,                 arm64_monterey: "661f94a4d7c4f68ff415bb5c184c8310d7af1eaf139159ba4163e19a20a5d6f0"
    sha256 cellar: :any,                 arm64_big_sur:  "bae9b452e72bafc0a8385457cc0d5f914b34905415f26b24b2e4da510658e7ce"
    sha256 cellar: :any,                 ventura:        "840ae5524a52327b13e088239491e115688e6de3b543cef073ae3b7f2d0b0015"
    sha256 cellar: :any,                 monterey:       "d6900fc7456b8bdb003af4da81629691f4a0c566140ec3f8a5215dbc686a6e6d"
    sha256 cellar: :any,                 big_sur:        "89eaf6e78bd174288fab321b22481950f650be157d487fd7127c7e24a2c533c1"
    sha256 cellar: :any,                 catalina:       "47e0d9e9d758d67a26716d436884fb7273298c202b7172610e1ceb0d394a6146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "735633ed1aa16ea88666586c80c7578bc9a6b052b83d4ce7fa81086156bd5d47"
  end

  depends_on "jpeg-turbo"
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
           "-I#{Formula["jpeg-turbo"].opt_include}",
           "-I#{include}", "-L#{lib}", "-lmng", "-o", "mngtree"

    resource("sample").stage do
      output = shell_output("#{testpath}/mngtree abydos.mng")
      assert_match "Starting dump of abydos.mng.", output
      assert_match "Done.", output
    end
  end
end
