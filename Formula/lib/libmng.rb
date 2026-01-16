class Libmng < Formula
  desc "MNG/JNG reference library"
  homepage "https://sourceforge.net/projects/libmng/"
  url "https://downloads.sourceforge.net/project/libmng/libmng-devel/2.0.3/libmng-2.0.3.tar.gz"
  sha256 "cf112a1fb02f5b1c0fce5cab11ea8243852c139e669c44014125874b14b7dfaa"
  license "Zlib"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "ac704e4cbe5c85dfd745778fe9b4167fbfb76b0479bf93095d3442d400b2bf7d"
    sha256 cellar: :any,                 arm64_sequoia:  "b689a6894b260bf093409615d0057769421cda51c8f4a7b59f06d692c6000104"
    sha256 cellar: :any,                 arm64_sonoma:   "6d30bcfb0460246fd86bd7f59dcf8b52b1e1fb3533ff8ff252a7cb23091ed9a9"
    sha256 cellar: :any,                 arm64_ventura:  "746b8bbf3aa5373c6545ce90fca5e84af114ecfce0f2b0e35fd7ec4c9853b15a"
    sha256 cellar: :any,                 arm64_monterey: "554dd35c3a73f040a23f212cbc64c0b9214b4cc4bfb9031341a71b695d64a4ec"
    sha256 cellar: :any,                 arm64_big_sur:  "f48583469a9c65f5f9733d43e2bbea2d004228d45ff0b7cdd101b4c44f05dfc5"
    sha256 cellar: :any,                 sonoma:         "17a8b7fffb5d320e5f0d6535aaf5d25ddde6da85bdaf5b4d260f0703a087a2e0"
    sha256 cellar: :any,                 ventura:        "68e6c1de7f5abe3668f229a99bde8ec9425d9f9136275c8218bf58b6839dff63"
    sha256 cellar: :any,                 monterey:       "6646b4ceca926b35750ef1abcfb15744ca286698f86b3c7407f8b5b9dfafa06a"
    sha256 cellar: :any,                 big_sur:        "a0cf8d4fb509d251ea7a559c1a5814466bd20fef027646c8cf1715ca85d5beea"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c552c0bec65776496b75f11bda010df689dba3ff7f00271113eb3a4e85941fdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10b82f077fcb7b44e8183c31aa73a5b6df139bcbba9becfd44222f8d29e0ceeb"
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
