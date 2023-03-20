class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.1.9.tar.gz"
  sha256 "c0dacc4ad506538f59ed45373b775748deddddc36e6d3c303f5069a59cacab08"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "GPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed89f20a5b615ab13fa8fc8049ecd0b8c0eec598cd3fb319f21df4fda98bc5b9"
    sha256 cellar: :any_skip_relocation, ventura:       "6f120c16676bddea65c9863cf3cebeccb3ce3ae9098471bf401b86a715826cd4"
    sha256 cellar: :any_skip_relocation, monterey:      "d4e88aeeb8d6f294103d421999bbb6c5d49941cda1a12866997ae2b45e044846"
    sha256 cellar: :any_skip_relocation, big_sur:       "ebd7f2895182e420f13eb5e8bb814a01b69b751596ef3c65b0e60df320cba2ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10a444b399b0bd4486654bb914fde8db8140b63feda87fa9804845f099653a0a"
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
