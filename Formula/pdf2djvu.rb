class Pdf2djvu < Formula
  desc "Create DjVu files from PDF files"
  homepage "https://jwilk.net/software/pdf2djvu"
  url "https://github.com/jwilk/pdf2djvu/releases/download/0.9.18.2/pdf2djvu-0.9.18.2.tar.xz"
  sha256 "9ea03f21d841a336808d89d65015713c0785e7295a6559d77771dc795333a9fa"
  license "GPL-2.0-only"
  revision 1
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
