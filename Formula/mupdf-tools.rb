class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.16.1-source.tar.xz"
  sha256 "6fe78184bd5208f9595e4d7f92bc8df50af30fbe8e2c1298b581c84945f2f5da"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80759203d101cc4b26cf21cfc724a1c0e3b7d896f2ab296d41e0cf829b30e76b" => :catalina
    sha256 "181249c8429832f2831ddadbf27dfc53b0e645f4dcb86b7a6ee237691a5f051e" => :mojave
    sha256 "2896fe7b33448061f1a05d09c8976ee506222d39c7eef06bf1a20467215a2114" => :high_sierra
  end

  conflicts_with "mupdf",
    :because => "mupdf and mupdf-tools install the same binaries."

  def install
    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "HAVE_GLUT=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
