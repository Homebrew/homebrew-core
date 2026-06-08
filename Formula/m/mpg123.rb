class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.33.6.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.33.6/mpg123-1.33.6.tar.bz2"
  sha256 "929a7c18ba662b8927aed4de229ad9ae8ab2b4806dd0f30b90113eb1b4e2195a"
  license "LGPL-2.1-only"
  compatibility_version 1

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "eb93e41985cb05d4209c4b7bdb4bc03a451a1c66f1c00f4296f07ed2a5cd229f"
    sha256 arm64_sequoia: "1d2b91939a37d8cc408561e533f5ade45945b8daa2be4efce2fd6fa7ab2548a8"
    sha256 arm64_sonoma:  "326924a8bdde4315f5692ebb7c4b54b24c77d05b3669052a5fb4b0894efe8464"
    sha256 sonoma:        "a6369b5d5e8b30eac98418531feb1c49f818af20ffa4902ec671d28909c0196f"
    sha256 arm64_linux:   "acf6b628abd6bb2620156ea57920026ef56795c73f5cfbbc37d23d88650ec698"
    sha256 x86_64_linux:  "3b28d270477d43f1033a292c433e7afbb29a78b18ffd534b63c6f3d9f3ac0947"
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
