class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.2.1.tar.gz"
  sha256 "04811b2e657ff98cd31e44b91a700c9f33c4c9dd93a36c8fc987de1f47c24024"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "GPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "685120f65d211d8c551962f2b7ba99bf58b5d2488498fb25ab70919b60135936"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b18ce2d2673c32032f3448fee24b12041f9295d308ae2cd8012673e5d493140e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d8932e2a1bb40be9409d1e6af6d317b358639854bb8bede8968cae75ddc47ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3352de5466ef543f219504b8ea5cb36ae4b86394230792b3e58a608fb44a5b09"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0a5db5e377eefc09019ff44dc4acead6bc7d39a5fbc905c69d2ec09f67b34a7"
    sha256 cellar: :any_skip_relocation, ventura:       "81ce2a5170ab9e89315a1120048f357ae8b7658fce50b53caab7856b30615e11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e4cdaa053ef9087f6876ec170bee57b33179a2f3878f16fd2ea2ad9d7218492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8cb1651c4cb5ff74bbf0de01df94c49af156e8dd92df446a6cc105bf50be73c"
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
