class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.18.2/pdf2djvu-0.9.18.2.tar.xz"
  sha256 "9ea03f21d841a336808d89d65015713c0785e7295a6559d77771dc795333a9fa"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/jwilk/pdf2djvu.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "a223836aa494f9a5802df7fb5ae7a2c8b5575a74bf749546b2e783cf530b764d"
    sha256 arm64_big_sur:  "06470c962399f1b58008ffb8e5a8dff9c849cdfe6522babc9926a9b9cb84b4c2"
    sha256 monterey:       "86bf8cdbe0e13b71dc346f2e0f21bcd039f3033f9e20da4b646c5ee61093227d"
    sha256 big_sur:        "9f11b5681a7876f915c5d836e8ee9b2f37229ae18f6ab301f334a9c6db6d8d20"
    sha256 catalina:       "87705efd2be759e47fc09907657f36b5d65868ea7d5228919702b80fc4fad38e"
    sha256 x86_64_linux:   "7a92afb35866e43ca5f3af3dd94e86e3ba312b993415275f82445eca2fe1fc4e"
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
  # TODO: switch to main repo after this PR is merged: https://github.com/Homebrew/formula-patches/pull/858
  patch do
    url "https://raw.githubusercontent.com/yurikoles/formula-patches/4c18443/pdf2djvu/main-use-pdf-link-Destination-copy-constructor.patch"
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
