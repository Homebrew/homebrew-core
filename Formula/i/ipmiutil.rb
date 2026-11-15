class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.2.3.tar.gz"
  sha256 "d26cae7318f12ab1098ec6c8ef2f017722659dda26eb81ebc6b50edc0453867a"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "GPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fda0c56a5e063da36dc5dac65d5177ea71b96a95291983dba841945420d19a4f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a5d4ccf2640a189664e4f20c510ed907fa2e48790cb9ab46cddb39e5b7d30ae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4abd8e74b57ceaa509a3bcf60e6c47036ba82a84d2ac27e4195f3e319356a6c9"
    sha256 cellar: :any,                 arm64_linux:       "196301447dfbe6861e9feb19d9ce087d3727ae2a5a347d5c61aa8e3eedf6bd61"
    sha256 cellar: :any,                 x86_64_linux:      "7be92b64f4654a015e09f28d74e09b362aa0d570cf8c680a65e271aa6610da82"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  conflicts_with "renameutils", because: "both install `icmd` binaries"

  deny_network_access!

  def install
    # Workaround for newer Clang
    ENV.append "CC", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    # autoconf 2.73 selects C23, which rejects the implicit declarations in this codebase
    ENV["ac_cv_prog_cc_c23"] = "no"

    # Darwin does not exist only on PowerPC
    inreplace "configure.ac", "test \"$archp\" = \"powerpc\"", "true" if OS.mac?

    system "autoreconf", "--force", "--install", "--verbose"
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
