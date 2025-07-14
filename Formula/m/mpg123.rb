class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.33.0.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.33.0/mpg123-1.33.0.tar.bz2"
  sha256 "2290e3aede6f4d163e1a17452165af33caad4b5f0948f99429cfa2d8385faa9d"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "94ad1c7b36056cdfcb57a256388ce840f0038e4f378a59159ad01a4be8287f50"
    sha256 arm64_sonoma:  "eefa497a2647b518e40dc34320857dac1a129c7d2e463487fa66aba74474d8b4"
    sha256 arm64_ventura: "b38b8d614bf7a54483963afcf1780059d47f0fd49a0e36411d0cddf274680f5b"
    sha256 sonoma:        "319f13d1d6f1d49275c498410ce423e04de0ed054cbccec588a3462b7ce0094b"
    sha256 ventura:       "f814d6bb9ec1a42df3065032a9632a0ad7459a4def5ad5aee96e60ffb152283f"
    sha256 arm64_linux:   "9196957b3a3af7fb4a810e8dff84cb9a4f9bffce5c4907f7c3e51e53966526be"
    sha256 x86_64_linux:  "60b726acd6f8eb1d3edc1a87e24f48ba514cab940d40ed41768649ea1ca5b635"
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
