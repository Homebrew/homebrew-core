class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.4.3.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.4.3.tar.gz"
  sha256 "b68db41956daf933828423aa30510e00c12d29ef5916e715e8d4e694fe66ca72"
  license "BSD-2-Clause"

  livecheck do
    url "https://waterlan.home.xs4all.nl/dos2unix/"
    regex(/href=.*?dos2unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99e6489bf197a6708e23fe54c6a3dd01c9faf91807aad90a21a4a19ba0b7a7fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5422ac9cfe1635baa4032ff17a4bc1d8e1e991f988164376e0a706851c6c5b99"
    sha256 cellar: :any_skip_relocation, monterey:       "7eb1a12fcb8ba89fcdaae8fe3b82cd9cb068d7edf7b966fabf80f0428476c329"
    sha256 cellar: :any_skip_relocation, big_sur:        "ecb0a8cfd9b346462640ab20b4f07aa8d2e8f10ce55c9f0539b0039d4979cb54"
    sha256 cellar: :any_skip_relocation, catalina:       "c1b511a509a5779a767a864b6d9ae26bbe9528dc2271726cc0e000071028a700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6536d3129b4d80da09c431a0ccafb48cfde1acb9896a78b11daca84a8b296b5"
  end

  def install
    args = %W[
      prefix=#{prefix}
      CC=#{ENV.cc}
      CPP=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      ENABLE_NLS=
      install
    ]

    system "make", *args
  end

  test do
    # write a file with lf
    path = testpath/"test.txt"
    path.write "foo\nbar\n"

    # unix2mac: convert lf to cr
    system "#{bin}/unix2mac", path
    assert_equal "foo\rbar\r", path.read

    # mac2unix: convert cr to lf
    system "#{bin}/mac2unix", path
    assert_equal "foo\nbar\n", path.read

    # unix2dos: convert lf to cr+lf
    system "#{bin}/unix2dos", path
    assert_equal "foo\r\nbar\r\n", path.read

    # dos2unix: convert cr+lf to lf
    system "#{bin}/dos2unix", path
    assert_equal "foo\nbar\n", path.read
  end
end
