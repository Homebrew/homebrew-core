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
    rebuild 1
    sha256 arm64_golden_gate: "56935f0083f633dda54cf02b939659c5476ba40102dd520126e8c3af762633f3"
    sha256 arm64_tahoe:       "5fcd87caeb9b6e6730d7de5c7738e785c84814c641d1ba9ac578a142d2b033f5"
    sha256 arm64_sequoia:     "80869bcfed43252f222be16fd652b8e691cb4a144778681853ed76e1d45a7143"
    sha256 arm64_linux:       "0de606c35f2bf02345bccfc76794d332ae69abe87e62bd40c8ff6ad00f774cd4"
    sha256 x86_64_linux:      "ce54f5c88411e9986a0a5dca95579a1342e19011c8220355961c3074c823f4f4"
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
