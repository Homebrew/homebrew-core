class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.18.2/pdf2djvu-0.9.18.2.tar.xz"
  sha256 "9ea03f21d841a336808d89d65015713c0785e7295a6559d77771dc795333a9fa"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "8dbf106ac4c9dfe5289f0c7ee4fdaf070e316071d118f67dd71449d6e67eb780"
    sha256 arm64_big_sur:  "fef8d14e81fc81cb6e26501ff1dce99536441dd17f56af303516d7e2fbd816ed"
    sha256 monterey:       "ab9607fc7dff6ef420d536d9a4c4d566360e9e7b46255c1da4ba31c46445d9d8"
    sha256 big_sur:        "49c458af3353f8e830cacb7419e4c7bf98d2f0364e9e42c7b04a7f73edd87955"
    sha256 catalina:       "2fc2051eb0bc35eefe10a3142a834e964388b9dbfaa4763c560107c8953bb68f"
    sha256 x86_64_linux:   "871a0c9204385f113ee5ce159b2cd0f371c2451fd9290a3fc624efd79bc68591"
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
