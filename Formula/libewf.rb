class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  # The main libewf repository is currently "experimental".
  url "https://github.com/libyal/libewf-legacy/releases/download/20140811/libewf-20140811.tar.gz"
  sha256 "b2c3a04ea7f49646518d108df8ea00fc0d2ca670064bb59428d8878ed8aef80d"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "d724c07aa4e7e063e0e065f91f9234cbe951be8888c4f9bdb9989698cfda0b6f" => :big_sur
    sha256 "ebe6e340255e59bff651b4e59807c45e279ec3d2058e308e147567f0a7d394b8" => :catalina
    sha256 "a74019c27df3e7e6a16b54c32c7dd9ed3f5eba83d31269647098f21b2fc4e788" => :mojave
  end

  head do
    url "https://github.com/libyal/libewf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-libfuse=no
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
