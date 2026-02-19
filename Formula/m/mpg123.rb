class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.33.4.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.33.4/mpg123-1.33.4.tar.bz2"
  sha256 "3ae8c9ff80a97bfc0e22e89fbcd74687eca4fc1db315b12607f27f01cb5a47d9"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "694eb298dbd62abd5678947b165361749c4d2099195442d16ac55123f8cf0ceb"
    sha256 arm64_sequoia: "ccc67ff7137b170a54c800fad04e144eba10dea38c070fbc0aeff6c738b18cd4"
    sha256 arm64_sonoma:  "02b9e1ef0fb6c5c8d2f705ff01d5be805fab0331281ae21e9bc01b5fa84b884c"
    sha256 sonoma:        "cbf64a7d8d9908619f5056dab2b4936300fbe2fce1e233df67a393ca9a5157ed"
    sha256 arm64_linux:   "0114c9506564aa4f8d4d9cae293160d7ade33c3b4c252b9e6b8b3aa6569ad8c6"
    sha256 x86_64_linux:  "2488c3e1d8c81c6483be8a601395c510ecfbf5b4f9768f8f897fa2bd7a154ad1"
  end

  def install
    args = %w[
      --with-module-suffix=.so
      --enable-static
    ]

    args << "--with-default-audio=coreaudio" if OS.mac?

    args << if Hardware::CPU.arm?
      "--with-cpu=aarch64"
    else
      "--with-cpu=x86-64"
    end

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
