class Libmng < Formula
  desc "MNG/JNG reference library"
  homepage "https://sourceforge.net/projects/libmng/"
  url "https://downloads.sourceforge.net/project/libmng/libmng-devel/2.0.3/libmng-2.0.3.tar.gz"
  sha256 "cf112a1fb02f5b1c0fce5cab11ea8243852c139e669c44014125874b14b7dfaa"
  license "Zlib"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "c1e187e0cbf4b730d8116e16edab09cc0b774101d4af55605239de0afe858d8f"
    sha256 cellar: :any,                 arm64_sequoia: "1292213d5064a51e8fac3d0f10401859bee1537daf1b922a2814ea97e24b8067"
    sha256 cellar: :any,                 arm64_sonoma:  "26b05e912102b23da3e0dc7c67c1ac6db8c4a71dc99a1069d95d3305840725bb"
    sha256 cellar: :any,                 sonoma:        "9bc364469479667acd2f770cc23c08214a0ed8df7cb807d0aad931c69e93b003"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fcc2b1c40ef908b1106fc6823a44071ec282337683fe27dbdb80d3d7bf1bd52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f91c91262cde7078e9bd6c31810e1fd3e338b85e03ca6467ce6deb1451edf3b"
  end

  depends_on "jpeg-turbo"
  depends_on "little-cms2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "sample" do
    url "https://telparia.com/fileFormatSamples/image/mng/abydos.mng"
    sha256 "4819310da1bbee591957185f55983798a0f8631c32c72b6029213c67071caf8d"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
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
