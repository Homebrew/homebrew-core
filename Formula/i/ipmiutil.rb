class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.2.2.tar.gz"
  sha256 "37f9bc8e6b18c1155e4d5ea38c87b83908b7acc7a44fbc5e3af493f26ef8b767"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "GPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24816a224f9fa258ad7c86b36f9ee07f2d327c0410d5e251158b763d94f5914c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "597555cd2a88d5c85e4da54dc3159c690e018ce69a28363a5a0dfe2c3825bf1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08735aa99f746d1f6718fcfe2e74db2840fb3d49cda8f7ff08f19bed2442dbdb"
    sha256 cellar: :any_skip_relocation, sonoma:        "673431272778abfd4ee2d782ab4be47bb47744c820419a6216f73b962f5f9263"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dfc5417038aac6b08f426630e297eef8e3247e0c3e501fa2dc133fdc6a3a2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b026ef33532c2472981201448f1c65523dce6db4fc6fdc6bbbd5fdfbccba8e3"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "renameutils", because: "both install `icmd` binaries"

  def install
    # Workaround for newer Clang
    ENV.append "CC", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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
    system bin/"ipmiutil", "delloem", "help"
  end
end
