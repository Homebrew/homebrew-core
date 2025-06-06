# typed: false
# frozen_string_literal: true

class Dvisvgm < Formula
  desc "Fast DVI to SVG converter"
  homepage "https://dvisvgm.de"
  url "https://github.com/mgieseki/dvisvgm/releases/download/3.5/dvisvgm-3.5.tar.gz"
  sha256 "41ea2e10fe6bdc4ce7672519cfc2998e5c30c8b29fbcd8901915c7dac7fa494c"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "llvm" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "texlive"
  depends_on "woff2"
  depends_on "zlib"
  # Optional: depends_on "ttfautohint"

  def install
    # Set environment variables to use LLVM clang
    llvm_bin = Formula["llvm"].opt_bin
    llvm_include = Formula["llvm"].opt_include
    llvm_lib = Formula["llvm"].opt_lib

    ENV["CC"] = "#{llvm_bin}/clang"
    ENV["CXX"] = "#{llvm_bin}/clang++"
    ENV["LDFLAGS"] = "-L#{llvm_lib} -L#{Formula["texlive"].opt_lib}"
    ENV["CPPFLAGS"] = "-I#{llvm_include} -I#{Formula["texlive"].opt_include}"
    ENV["CXXFLAGS"] = "-stdlib=libc++ -I#{llvm_include}/c++/v1"

    system "./configure", *std_configure_args, "--disable-silent-rules"
    # Optional: "--with-ttfautohint" if ttfautohint is a dependency
    system "make"
    system "make", "install"
  end

  test do
    # Test by converting a minimal DVI file to SVG
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Hello, world!
      \\end{document}
    EOS
    system "latex", "test.tex"
    system bin/"dvisvgm", "test.dvi"
    assert_path_exists testpath/"test.svg"
  end
end
