class Dos2unix < Formula
  desc "Convert text between DOS, UNIX, and Mac formats"
  homepage "https://waterlan.home.xs4all.nl/dos2unix.html"
  url "https://waterlan.home.xs4all.nl/dos2unix/dos2unix-7.4.4.tar.gz"
  mirror "https://fossies.org/linux/misc/dos2unix-7.4.4.tar.gz"
  sha256 "28a841db0bd5827d645caba9d8015e3a71983dc6e398070b5287ee137ae4436e"
  license "BSD-2-Clause"

  livecheck do
    url "https://waterlan.home.xs4all.nl/dos2unix/"
    regex(/href=.*?dos2unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "409862cf46f3a9e797e00fadd99b1b0ab91fa3b35ca90850201da18d8237736a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e27df73c86db8d637e45c7f3340085167283bea6f851193012fb2971e41383bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "550706a3e815721c59b383fe9f96b8acb37d26db438e63ddd16b12a274ccdb2d"
    sha256 cellar: :any_skip_relocation, ventura:        "03551760b2512e697def9b15f4f5e2334c28b8a8dcef869eb0d1d84e8a585fd1"
    sha256 cellar: :any_skip_relocation, monterey:       "77f8c69017871d222c573bd5feea094359bee82bed4fca43e8b813013a96b266"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e5527b8459a486b36d31d8a71928a3e3bf1174ceb5381a13efef5b443dadf32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62e5062ae0c2adaf715a86fed63774c0761e92628635abfc5f2490da588f37e5"
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
