class Bashdb < Formula
  desc "Bash shell debugger"
  homepage "https://bashdb.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bashdb/bashdb/5.0-1.1.2/bashdb-5.0-1.1.2.tar.bz2"
  version "5.0-1.1.2"
  sha256 "30176d2ad28c5b00b2e2d21c5ea1aef8fbaf40a8f9d9f723c67c60531f3b7330"
  license "GPL-2.0-or-later"

  # We check the "bashdb" directory page because the bashdb project contains
  # various software and bashdb releases may be pushed out of the SourceForge
  # RSS feed.
  livecheck do
    url "https://sourceforge.net/projects/bashdb/files/bashdb/"
    strategy :page_match
    regex(%r{href=(?:["']|.*?bashdb/)?v?(\d+(?:[.-]\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f53afdb7dc83b30c3347c729b38ee0da913198c9c5afc6e67727e36960602f1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f53afdb7dc83b30c3347c729b38ee0da913198c9c5afc6e67727e36960602f1e"
    sha256 cellar: :any_skip_relocation, monterey:       "d48fff200662804b52e9688a80e8931f56a5033235903b9ce35cb8908f8ba61a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e49b34af9e621c91f6a101bfe327182f956f7b25b48d9fc7804e5d8ea0277263"
    sha256 cellar: :any_skip_relocation, catalina:       "0ab6de48ce871bc7b6abc582154b425350a70b7f2ecadd3b303c7a91dafc3c41"
    sha256 cellar: :any_skip_relocation, mojave:         "0ab6de48ce871bc7b6abc582154b425350a70b7f2ecadd3b303c7a91dafc3c41"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0ab6de48ce871bc7b6abc582154b425350a70b7f2ecadd3b303c7a91dafc3c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f53afdb7dc83b30c3347c729b38ee0da913198c9c5afc6e67727e36960602f1e"
  end

  depends_on "autoconf" => :build # due to patch
  depends_on "automake" => :build # due to patch
  depends_on "bash"

  # Bypass error with Bash 5.1: "error: This package is only known to work with Bash 5.0"
  # Upstream ref: https://sourceforge.net/p/bashdb/code/ci/6daffb5c7337620b429f5e94c282b75a0777fc82/
  patch :DATA

  def install
    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", "--with-bash=#{HOMEBREW_PREFIX}/bin/bash",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/bashdb --version 2>&1")
  end
end

__END__
--- a/configure.ac
+++ b/configure.ac
@@ -107,7 +107,7 @@
 [bash_minor=`$SH_PROG -c 'echo ${BASH_VERSINFO[1]}'`]
 bash_5_or_greater=no
 case "${bash_major}.${bash_minor}" in
-  'OK_BASH_VERS' | '5.0')
+  'OK_BASH_VERS' | '5.0' | '5.1')
     bash_5_or_greater=yes
     ;;
   *)
@@ -118,7 +118,8 @@

 AC_ARG_WITH(dbg-main, AC_HELP_STRING([--with-dbg-main],
                   [location of dbg-main.sh]),
-		  DBGR_MAIN=$withval)
+		  [DBGR_MAIN=$withval]
+		  [DBGR_MAIN=${ac_default_prefix/prefix}/bashdb/bashdb-main.inc])
 AC_SUBST(DBGR_MAIN)

 mydir=$(dirname $0)
