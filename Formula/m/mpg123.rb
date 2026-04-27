class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://www.mpg123.de/download/mpg123-1.33.5.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/mpg123/mpg123/1.33.5/mpg123-1.33.5.tar.bz2"
  sha256 "0d7ebc8da0aff3ca383c8c6b5a6adbe402ee5bb256685b8c5499f3a739f9d6dd"
  license "LGPL-2.1-only"
  compatibility_version 1

  livecheck do
    url "https://www.mpg123.de/download/"
    regex(/href=.*?mpg123[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "40a6d592a480065d88ad9cf101b226a9b2080736c58fb2ff03d47ffe1e5ad528"
    sha256 arm64_sequoia: "c75904baf633b0ef6e96f7d316568a9101ea89c95b47c81792ceb3b4ca78b206"
    sha256 arm64_sonoma:  "31fc98dc70d800d7b3a3709309d9bacbd44399eb3784f908bcaa4f33cba60d43"
    sha256 sonoma:        "cfe19c8119f37eb5c2c0b295f1cb26c6de66150590848391a6b4a539ea249ad1"
    sha256 arm64_linux:   "b07735c1f6b5a3d1a9d0803a048e66cc09fa53407f7b3cdda659ef8f80873de4"
    sha256 x86_64_linux:  "48f2124f53ae9d385ae30cd94a99ef90085c32f7c8b4f4674528d4db4aaf94f6"
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
