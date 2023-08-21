class AutoconfAT269 < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf"
  url "https://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz"
  mirror "https://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.gz"
  sha256 "954bd69b391edc12d6a4a51a2dd1476543da5c6bbf05a95b59dc0dd6fd4c2969"
  license all_of: [
    "GPL-3.0-or-later",
    "GPL-3.0-or-later" => { with: "Autoconf-exception-3.0" },
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa8878f7ae82d8c8b2f1de7d330ffe52d797aec62c955fd0d62bcf5557ffd4b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa8878f7ae82d8c8b2f1de7d330ffe52d797aec62c955fd0d62bcf5557ffd4b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7b28e5cdf538418baea43d1d5638a1df52161ef0cd198ee1f261cdc61ac6636"
    sha256 cellar: :any_skip_relocation, ventura:        "210d6b15bb404f7711955bfeb60dce45a8bd34bda84d043ea32552571bb3d1d6"
    sha256 cellar: :any_skip_relocation, monterey:       "b06ba90b16a3d6d38a2954e5c02710a4225a7e82bd1a5c30e1b7574dbfd1b2b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4a0ef0b0b653836a212225fbb5345fb58e898ed7a24cb8386a4169496bbfde3"
    sha256 cellar: :any_skip_relocation, catalina:       "e4a0ef0b0b653836a212225fbb5345fb58e898ed7a24cb8386a4169496bbfde3"
    sha256 cellar: :any_skip_relocation, mojave:         "f91f5a4d756aa9f3f73b725578568f5310c40adf702338b656876a5016cca401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a81e31050fea7e78203415941a85de809015059eb2a3e356afcfe73ec715237d"
  end

  keg_only :versioned_formula

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
    cp prefix/"share/autoconf/autotest/autotest.m4", "autotest.m4"
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
