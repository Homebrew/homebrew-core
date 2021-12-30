class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.1.8.tar.gz"
  sha256 "b14357b9723e38a19c24df2771cff63d5f15f8682cd8a5b47235044b767b1888"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "GPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d2870b00ddad6b22295009482c51e7d699dd8d0d0c32fafe3a5699c6b30e3f45"
    sha256 cellar: :any_skip_relocation, monterey:      "b8c88d6612da4dd1e97aaf3af77867d4f135b73ad9cd1f165e6e255804b4aa20"
    sha256 cellar: :any_skip_relocation, big_sur:       "3cb5c77d4305480078d8a4cfbab0118a5e8304a13eff06ac95ba9575f9ec06d1"
    sha256 cellar: :any_skip_relocation, catalina:      "ad8fc089b714a2286884168e7ce78e4cfb9a2c045e7daf9ee77eae3524bb0f8f"
    sha256 cellar: :any_skip_relocation, mojave:        "af41d4e3592cea0b3151276cff34bfabc810b47af165dc16436e8af30877e52e"
    sha256 cellar: :any_skip_relocation, high_sierra:   "502b711bfa0411d970ac6fc5dabd65e04a0a80b0bf0adead2fa1e965f2079050"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed08858c9437926761cfa4989285194d32f137fe3097eedde464cce544b6768e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  conflicts_with "renameutils", because: "both install `icmd` binaries"

  def install
    # Darwin does not exist only on PowerPC
    inreplace "configure.ac", "test \"$archp\" = \"powerpc\"", "true"
    system "autoreconf", "-fiv"

    system "./configure", *std_configure_args,
                          "--disable-lanplus",
                          "--enable-sha256",
                          "--enable-gpl"

    system "make", "TMPDIR=#{ENV["TMPDIR"]}"
    # DESTDIR is needed to make everything go where we want it.
    system "make", "prefix=/",
                   "DESTDIR=#{prefix}",
                   "varto=#{var}/lib/#{name}",
                   "initto=#{etc}/init.d",
                   "sysdto=#{prefix}/#{name}",
                   "install"
  end

  test do
    system "#{bin}/ipmiutil", "delloem", "help"
  end
end
