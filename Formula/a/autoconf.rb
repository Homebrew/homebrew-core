class Autoconf < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf"
  url "https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz"
  mirror "https://ftpmirror.gnu.org/autoconf/autoconf-2.72.tar.gz"
  sha256 "afb181a76e1ee72832f6581c0eddf8df032b83e2e0239ef79ebedc4467d92d6e"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-3.0-or-later" => { with: "Autoconf-exception-3.0" },
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb39057e87dd9cb940bee15ff5b5172952a0350e59b14a6f55b8006a07813186"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb39057e87dd9cb940bee15ff5b5172952a0350e59b14a6f55b8006a07813186"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb39057e87dd9cb940bee15ff5b5172952a0350e59b14a6f55b8006a07813186"
    sha256 cellar: :any_skip_relocation, sonoma:         "12368e33b89d221550ba9e261b0c6ece0b0e89250fb4c95169d09081e0ebb2dd"
    sha256 cellar: :any_skip_relocation, ventura:        "12368e33b89d221550ba9e261b0c6ece0b0e89250fb4c95169d09081e0ebb2dd"
    sha256 cellar: :any_skip_relocation, monterey:       "12368e33b89d221550ba9e261b0c6ece0b0e89250fb4c95169d09081e0ebb2dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d760774b6bcad93822e666a8a2ee8557f674eba7f784b9ab9e397313378474b8"
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
