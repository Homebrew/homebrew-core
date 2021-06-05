class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.28.0.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.28.0/mpg123-1.28.0.tar.bz2"
  sha256 "e49466853685026da5d113dc7ff026b1b2ad0b57d78df693a446add9db88a7d5"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "8e631fd95a2cabd7e7caacb31ad97159dcf5a42a6eabdc53f73a817af17857ff"
    sha256 big_sur:       "c5a39efb50f4f4925e03c5902d427da5a5157f4b28e29b1fd29ca243e3b78ddd"
    sha256 catalina:      "8d330f527bc88f8e3a59f6b09c61e26017e2ce06b9c3efff6fd004ffa0978e56"
    sha256 mojave:        "ebeb928950808e467e8816e2856ac7a43990301f09f0c7d19cb1100490a48aae"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
    ]

    on_macos do
      args << "--with-default-audio=coreaudio"
    end

    args << if Hardware::CPU.arm?
      "--with-cpu=aarch64"
    else
      "--with-cpu=x86-64"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
