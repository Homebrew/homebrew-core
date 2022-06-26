class PgTop < Formula
  desc "Monitor PostgreSQL processes"
  homepage "https://pg_top.gitlab.io"
  url "https://ftp.postgresql.org/pub/projects/pgFoundry/ptop/pg_top/3.7.0/pg_top-3.7.0.tar.bz2"
  mirror "https://mirrorservice.org/sites/ftp.postgresql.org/projects/pgFoundry/ptop/pg_top/3.7.0/pg_top-3.7.0.tar.bz2"
  sha256 "c48d726e8cd778712e712373a428086d95e2b29932e545ff2a948d043de5a6a2"
  revision 3

  # 4.0.0 is out, but unfortunatley no longer supports OS/X.  Therefore
  # we only look for the latest 3.x release until upstream adds OS/X support back.
  livecheck do
    url "https://gitlab.com/pg_top/pg_top.git"
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "508be024321986bb022736c593bdc5d6cef586aaf3af76fc9a517ec9f7b1a491"
    sha256 cellar: :any,                 arm64_big_sur:  "70a878b8d6ae8f3fff2303ca0e50cf294ce7918dec0eca0050c983fa237f8e61"
    sha256 cellar: :any,                 monterey:       "b6a0020d75408990a336980207ef7ee71104f79b53322482a89cd80612842672"
    sha256 cellar: :any,                 big_sur:        "770ec08d04f5f88d91f99855fb5ac13466734b7b396a0bf499387a02490cc8b8"
    sha256 cellar: :any,                 catalina:       "00231ec96d368d18286b69104979b2d35307f02e2f5acf54293f97b7619803ff"
    sha256 cellar: :any,                 mojave:         "1110da076403c8f3030421ce4fbb5acb51d61c71102564aa00db9611d08b50c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed92710360b1ef0e9c531dad918f72d69986cb128467c5124fe39908b44f5aa4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "postgresql"

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-postgresql=#{Formula["postgresql"].opt_prefix}"
    (buildpath/"config.h").append_lines "#define HAVE_DECL_STRLCPY 1"
    # On modern OS/X [v]snprinf() are macros that optionally add some security checks
    # In c.h this package provides their own declaration of these assuming they're
    # normal functions.  This collides with macro expansion badly but since we don't
    # need the declarations anyway just change the string to something harmless:
    inreplace "c.h", "snprintf", "unneeded_declaration_of_snprintf"
    # This file uses "vm_stats" as a symbol name which conflicts with vm_stats()
    # function in the SDK:
    inreplace "machine/m_macosx.c", "vm_stats", "vm_stats_data"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pg_top -V")
  end
end
