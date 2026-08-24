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
    sha256 arm64_tahoe:   "d2b89e48bcc3696606b22560e530afd8c7cc41745ffdbccdaf03eb414f83ce5b"
    sha256 arm64_sequoia: "dee55256d8b72036f5512f5c6c5ff526e90ef741a321cc3abb1703efd2018625"
    sha256 arm64_sonoma:  "792b27e088e7eed175fdf4297ff387cd6301e4a831c2d5e19767cf2cb16f4d0d"
    sha256 sonoma:        "fc2714c39fba97197e264255efe3e6359f2aa2020a11c877270ddc644718f50c"
    sha256 arm64_linux:   "abb910c7c95fa1ed5f135d9c8b877152333b4233dc71a93d4c7ccd2e480b861c"
    sha256 x86_64_linux:  "562e24e2eb6eb60a92ed469b94dda9974f3f4d0e56f8a47e877344c4013fdee1"
  end

  depends_on "openssl@3"

  on_macos do
    depends_on "gcc"
  end

  conflicts_with "ghostscript", because: "both install `gsc` binary"
  conflicts_with "gerbil-scheme", because: "both install `gsc` binary"
  conflicts_with "scheme48", because: "both install `scheme-r5rs` binaries"

  # Clang is slower both for compiling and for running output binaries
  fails_with :clang

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
      s.gsub! %r{/usr/local/opt/openssl(@\d(\.\d)?)?}, formula_opt_prefix("openssl@3")
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
