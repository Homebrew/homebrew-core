class GambitScheme < Formula
  desc "Implementation of the Scheme Language"
  homepage "https://gambitscheme.org/"
  url "https://github.com/gambit/gambit/archive/refs/tags/v4.9.8.tar.gz"
  sha256 "0ec19b755dbda6c540e9e60b7235d801f26f40c2f211ddfb729b756218bcc873"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "71b7111dd6f7b3c1bd0e711493cfc468dd6ba15ae5236811c9642496960ca53a"
    sha256 arm64_tahoe:       "18972a99033b1bd893b769bd0e6a29267a1e7e8069494512a007a6d25b32c7f6"
    sha256 arm64_sequoia:     "5d4867bde22dc23c0821177f759f25f8db1c1e3e6b75c24253c5f7239e89e146"
    sha256 arm64_linux:       "eefa71bc2bac0b446c63b84d897ed9a9b478ceeef763502039780aa339a181c1"
    sha256 x86_64_linux:      "fe6904a521d67c22c221a32c9acf79c1353143a84a55a79a32cccf64bc166886"
  end

  depends_on "openssl@4"

  on_macos do
    depends_on "gcc"
  end

  conflicts_with "ghostscript", because: "both install `gsc` binary"
  conflicts_with "gerbil-scheme", because: "both install `gsc` binary"
  conflicts_with "scheme48", because: "both install `scheme-r5rs` binaries"

  # Clang is slower both for compiling and for running output binaries
  fails_with :clang

  deny_network_access!

  def install
    args = %W[
      --prefix=#{prefix}
      --docdir=#{doc}
      --infodir=#{info}
      --enable-single-host
      --enable-default-runtime-options=f8,-8,t8
      --enable-openssl
    ]

    system "./configure", *args

    # Fixed in gambit HEAD, but they haven't cut a release
    inreplace "config.status" do |s|
      s.gsub! %r{/usr/local/opt/openssl(@\d(\.\d)?)?}, formula_opt_prefix("openssl@4")
    end
    system "./config.status"

    system "make"
    ENV.deparallelize
    system "make", "install"

    # fix lisp file install location
    elisp.install share/"emacs/site-lisp/gambit.el"
  end

  test do
    assert_equal "0123456789", shell_output("#{bin}/gsi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
  end
end
