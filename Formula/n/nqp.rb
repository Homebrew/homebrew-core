class Nqp < Formula
  desc "Lightweight Raku-like environment for virtual machines"
  homepage "https://github.com/Raku/nqp"
  url "https://github.com/Raku/nqp/releases/download/2023.09/nqp-2023.09.tar.gz"
  sha256 "45f36c0db1658dc0064e23d450cd6d9e8ff01528bc16a8d83e1472707066d968"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f0b4f93967dac5df5a8bba9b732ecd4a52072e1168085d97fd8431740189d354"
    sha256 arm64_ventura:  "4c74d4066cd71549096ac3191cc78089bef18b9746e88772854e6f4c4a0ec42d"
    sha256 arm64_monterey: "fb1cb67c385021efeff8a7e8e04d158a92b58c48191cbcf4c2d58de4dfeeb5c2"
    sha256 arm64_big_sur:  "1f8169acc8229f93f89e0b6373b5169c6b6078caaecc6ead52af834b22b765b9"
    sha256 sonoma:         "04260e11e92459bfb03d708df3914c8d47aedb38b4a09fec3c5b1729327c5578"
    sha256 ventura:        "3c72516a1dc5e97f3c41dd1ed1146238b38aa3b8efb5bb9450117d5cd65cd6ea"
    sha256 monterey:       "7507b6265bb772c5f6197b6a5227c861613f544ddac8cf604db2fea465a1ea38"
    sha256 big_sur:        "066b60abb9b75059eddd1ef3a5cdb0d14a5f407f27cd3d458b382de69bf91d19"
    sha256 x86_64_linux:   "8312446b7eec93894f6d915985aa2eb8e9c97bcbdbc947a541dc2ef6c699b70f"
  end

  depends_on "libtommath"
  depends_on "libuv"
  depends_on "moarvm"

  uses_from_macos "perl" => :build
  uses_from_macos "libffi"

  conflicts_with "rakudo-star", because: "rakudo-star currently ships with nqp included"

  def install
    ENV.deparallelize

    # Work around Homebrew's directory structure and help find moarvm libraries
    inreplace "tools/build/gen-version.pl", "$libdir, 'MAST'", "'#{Formula["moarvm"].opt_share}/nqp/lib/MAST'"

    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-moar=#{Formula["moarvm"].bin}/moar"
    system "make"
    system "make", "install"
  end

  test do
    out = shell_output("#{bin}/nqp -e 'for (0,1,2,3,4,5,6,7,8,9) { print($_) }'")
    assert_equal "0123456789", out
  end
end
