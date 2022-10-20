class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.1.8.tar.gz"
  sha256 "b14357b9723e38a19c24df2771cff63d5f15f8682cd8a5b47235044b767b1888"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "GPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7fcbfd7ad87af3180be0a707028d053d40ac5015e56492215b31ecdeb12594d1"
    sha256 cellar: :any_skip_relocation, monterey:      "2ccf8da9a193781f4afc3df39aed16631347dc6c9dc54e2ff18e900ea2f8bd30"
    sha256 cellar: :any_skip_relocation, big_sur:       "89d488a24b1d2e48cb4b59f97a6728f40bb6f5537ad216990d1a8cb7cf126935"
    sha256 cellar: :any_skip_relocation, catalina:      "22cbdf5b31cbbe32d43972f8f65b9e7cd1ab4b502fc853bb5ec4ba8c881da217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97654675eb07ff4c52dfc12434302e4c57a50be29e18839d063e9f2acf4955b1"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "renameutils", because: "both install `icmd` binaries"

  def install
    # Darwin does not exist only on PowerPC
    if OS.mac?
      inreplace "configure.ac", "test \"$archp\" = \"powerpc\"", "true"
      system "autoreconf", "--force", "--install", "--verbose"
    end

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
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
