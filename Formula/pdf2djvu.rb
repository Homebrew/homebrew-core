class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.18.2/pdf2djvu-0.9.18.2.tar.xz"
  sha256 "9ea03f21d841a336808d89d65015713c0785e7295a6559d77771dc795333a9fa"
  license "GPL-2.0-only"
  revision 4
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "af3e5a67dcbf23897f2e90d32bc312e5bb5629b4a1cbde594ebe58da48ebc228"
    sha256 arm64_big_sur:  "009b759db93148c102a9d1bcfbd5e713389a024aed70187fac8eb8fde08e20f6"
    sha256 monterey:       "3a94580e6a0e76d30ea5e5feb249ed92b9f2835d51c8cc5ac9725a04f838c432"
    sha256 big_sur:        "f122c8f6136b441354adaa8d7cb92952a4e12b279c3df28ea4e7a1cfafacef9c"
    sha256 catalina:       "0686d5eca77bcf30388276dcc75498da713d0b73a12bd4958f260ef80c654304"
    sha256 x86_64_linux:   "f54bbb88a130a463c8070dd6b35a365b3a57df2bb1f3cb13ae05da10f1a15a6f"
  end

  depends_on "pkg-config" => :build
  depends_on "djvulibre"
  depends_on "exiv2"
  depends_on "gettext"
  depends_on "poppler"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # poppler compiles with GCC

  # poppler 22.04.0 compatibility, remove in next release
  patch do
    url "https://github.com/jwilk/pdf2djvu/commit/e170ad557d5f13daeeac047dfaa79347bbe5062f.patch?full_index=1"
    sha256 "424c4fe330e01d9fbf33eb7bce638ea6d3788e1e1b8b3932364257631c867d8a"
  end

  # poppler 22.04.0 compatibility, remove in next release

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e0c880b/pdf2djvu/main-use-pdf-link-Destination-copy-constructor.patch"
    sha256 "3d1e9fc0d7f2861142721befff9e33b5c2665dacc78ac12b613af7b1e6fb0ce6"
  end

  # poppler 22.04.0 compatibility, remove in next release
  patch do
    url "https://github.com/jwilk/pdf2djvu/commit/956fedc7e0831126b9006efedad5519c14201c52.patch?full_index=1"
    sha256 "4ab8d3ff7f8474b86949d4acf23da6f6ac77303e94feeb849fb3298358efd23f"
  end

  def install
    ENV.append "CXXFLAGS", "-std=gnu++17" # poppler uses std::optional
    ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_AUTO_PTR=1" if ENV.compiler == :clang
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    cp test_fixtures("test.pdf"), "test.pdf"
    system "#{bin}/pdf2djvu", "-o", "test.djvu", "test.pdf"
    assert_predicate testpath/"test.djvu", :exist?
  end
end
