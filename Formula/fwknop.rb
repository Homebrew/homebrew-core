class Fwknop < Formula
  desc "Single Packet Authorization and Port Knocking"
  homepage "https://www.cipherdyne.org/fwknop/"
  url "https://github.com/mrash/fwknop/archive/2.6.10.tar.gz"
  sha256 "a7c465ba84261f32c6468c99d5512f1111e1bf4701477f75b024bf60b3e4d235"
  license "GPL-2.0-or-later"
  head "https://github.com/mrash/fwknop.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "1855b9dc8ff17dbc1cc3c07512d3ebb81f80b5e45b5ab918da8df3ac48cd86d5"
    sha256 arm64_big_sur:  "b786ab1814ba91ca06d3d638e7c1aad3a57e472ea957ab3f45f72c82063176db"
    sha256 monterey:       "2c9f26be45a730f30e6c950f842e76d982bf58afabf0710c2c4add41eda497d6"
    sha256 big_sur:        "c231ca3d7d20435ed0ae401294d5e6352ac811e4376635f93afdd71eb2b08656"
    sha256 catalina:       "2c2faa8fc9328c53553c4b5bee81c4b8b6e8a43ed54f49d9ab6646bea0529e5e"
    sha256 x86_64_linux:   "370466dcba3753ce5cd890395d91fae86f13d656b97bb1a379cccd774ace12d1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gpgme"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "iptables"
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # fwknop-config_init.o:(.bss+0x4): multiple definition of `log_level_t'
    # Issue ref: https://github.com/mrash/fwknop/issues/305
    ENV.append_to_cflags "-fcommon" if OS.linux?

    # Fix failure with texinfo while building documentation.
    inreplace "doc/libfko.texi", "@setcontentsaftertitlepage", "" unless OS.mac?

    system "./autogen.sh"
    args = *std_configure_args + %W[
      --disable-silent-rules
      --sysconfdir=#{etc}
      --with-gpgme
      --with-gpg=#{Formula["gnupg"].opt_bin}/gpg
    ]
    args << "--with-iptables=#{Formula["iptables"].opt_prefix}" unless OS.mac?
    system "./configure", *args
    system "make", "install"
  end

  test do
    touch testpath/".fwknoprc"
    chmod 0600, testpath/".fwknoprc"
    system "#{bin}/fwknop", "--version"
  end
end
