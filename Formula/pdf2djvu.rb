class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.18.2/pdf2djvu-0.9.18.2.tar.xz"
  sha256 "9ea03f21d841a336808d89d65015713c0785e7295a6559d77771dc795333a9fa"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "000d5cd9452f8aaac330b42b25c14638751e43820dd102be724871b8bc917b9e"
    sha256 arm64_big_sur:  "f1bb42d1c85fae015352fe75c4fb24b979e6cce7dfb0b567e86e71676bc3fa76"
    sha256 monterey:       "1d7fc618731a7489b251e1bd96a1ed1a15980751e0ae36e7c062b3876ba61f96"
    sha256 big_sur:        "8f8987f6719bedee79d44c7071aa452de3ee49a0067bacc3963e365f2fe5c9de"
    sha256 catalina:       "796540989e95c5709006a419616a4f030bee49281faab284562a27883e2f584c"
    sha256 x86_64_linux:   "808dade3d55a964134d062ebec8df6f12c285ee9540f1fdba78f5df648279375"
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
