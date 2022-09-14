class FontsEncodings < Formula
  desc "Font encoding tables for libfontenc"
  homepage "https://gitlab.freedesktop.org/xorg/font/encodings"
  url "https://www.x.org/archive/individual/font/encodings-1.0.6.tar.xz"
  sha256 "77e301de661f35a622b18f60b555a7e7d8c4d5f43ed41410e830d5ac9084fc26"
  license :public_domain

  depends_on "font-util"   => :build
  depends_on "mkfontscale" => :build
  depends_on "util-macros" => :build

  def install
    configure_args = std_configure_args + %W[
      --with-fontrootdir=#{share}/fonts/X11
    ]

    system "./configure", *configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_predicate share/"fonts/X11/encodings/encodings.dir", :exist?
  end
end
