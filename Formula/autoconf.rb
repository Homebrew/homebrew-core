class Autoconf < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf"
  url "https://ftp.gnu.org/gnu/autoconf/autoconf-2.71.tar.gz"
  mirror "https://ftpmirror.gnu.org/autoconf/autoconf-2.71.tar.gz"
  sha256 "431075ad0bf529ef13cb41e9042c542381103e80015686222b8a9d4abef42a1c"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-3.0-or-later" => { with: "Autoconf-exception-3.0" },
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3d366c98b0da7a0a4f352eef49af9d612ac7aea4ffe420d49ff12bd90007415"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6279cc6294da77a87b2e08783f39a97e8678bde9b3e2899685879cabee6d2945"
    sha256 cellar: :any_skip_relocation, monterey:       "de8f4aa4123d307ad8bb11b1c685538224dc39939085fd00af928c5099c4202d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0aa64f171bac19ce6ac0c0ca697f30658db78cf175550dfde3dbda907b7f2500"
    sha256 cellar: :any_skip_relocation, catalina:       "258a94bef23057c52818adf64d682af20bc6e09b46eac135047e2b87fc8206c7"
    sha256 cellar: :any_skip_relocation, mojave:         "e94578bf4b4832baef1c9bbb40cb4da5fdbd9c66be5ed8d070f78be5f0cca618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f9a73292e64f19ec504459ee7f8b7f11f1e472d18252499705a9fc289c43f85"
  end

  depends_on "m4"
  uses_from_macos "perl"

  def install
    if OS.mac?
      ENV["PERL"] = "/usr/bin/perl"

      # force autoreconf to look for and use our glibtoolize
      inreplace "bin/autoreconf.in", "libtoolize", "glibtoolize"
      # also touch the man page so that it isn't rebuilt
      inreplace "man/autoreconf.1", "libtoolize", "glibtoolize"
    end

    system "./configure", "--prefix=#{prefix}", "--with-lispdir=#{elisp}"
    system "make", "install"

    rm_f info/"standards.info"
  end

  test do
    cp pkgshare/"autotest/autotest.m4", "autotest.m4"
    system bin/"autoconf", "autotest.m4"

    (testpath/"configure.ac").write <<~EOS
      AC_INIT([hello], [1.0])
      AC_CONFIG_SRCDIR([hello.c])
      AC_PROG_CC
      AC_OUTPUT
    EOS
    (testpath/"hello.c").write "int foo(void) { return 42; }"

    system bin/"autoconf"
    system "./configure"
    assert_predicate testpath/"config.status", :exist?
    assert_match(/\nCC=.*#{ENV.cc}/, (testpath/"config.log").read)
  end
end
