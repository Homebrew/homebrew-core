class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.33.7.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.33.7/mpg123-1.33.7.tar.bz2"
  sha256 "31d0e35a4ca567ec9b5ebda6c3062bb4435d6d3eacd6ef0d95cadd7854dc03ee"
  license "LGPL-2.1-only"
  compatibility_version 1

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "acabaed07a2aa95e360e1047df604cb45845254f2ff136671b9fb0d4bafc69ce"
    sha256 arm64_sequoia: "9c77394d85530cafc6a0a753e98fa2a7f00e8df87e3e3c57411a7b896ce2e0f4"
    sha256 arm64_sonoma:  "3d42cc9e1a044fe3c566e909bd122bb6a5b01f2696c110e915b2aee52a0c3142"
    sha256 sonoma:        "88dbf616a98aea2f4229012c97dad6e243688bac7c76e63b410187cbb038cd08"
    sha256 arm64_linux:   "9abac5b4cc29fd338a37d149afc0e271750327e1a2046b4c62190d8221a6cf13"
    sha256 x86_64_linux:  "abaf6777eb51cb88f6d56dd33e9172bc7a208ac94b892652a3b422e5efa97ce0"
  end

  deny_network_access!

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
