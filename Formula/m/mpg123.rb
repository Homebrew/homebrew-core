class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.32.6.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.32.6/mpg123-1.32.6.tar.bz2"
  sha256 "ccdd1d0abc31d73d8b435fc658c79049d0a905b30669b6a42a03ad169dc609e6"
  license "LGPL-2.1-only"

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "b9a8b819e65b8bb7fa2d4909faa589c9301d052f04eb00186effef23112a39d9"
    sha256 arm64_ventura:  "f424509cc8bf121b69f37a3ff36bfeff5ad1a0057879e9f08be90c3b63978341"
    sha256 arm64_monterey: "baa625d0c093b90eb99a5226946d2f3be2c47df626d159f2f61117dc99f09cd7"
    sha256 sonoma:         "dd426cc673801c0515ded4f30ff54274a7d8bde6b36d4ef1e06433a85e6e10a3"
    sha256 ventura:        "e0fd266ec58b02f0fd32b4927daea37f72bec491da77dc5465f0ea10671c807b"
    sha256 monterey:       "1ed57deb295473caedd0fc43f2d620137c724364c81cfa780349d7d57758bde7"
    sha256 x86_64_linux:   "377959a0f976c54deaaa93aae99c2200987d6d56a675c55bd9264653611000a3"
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
