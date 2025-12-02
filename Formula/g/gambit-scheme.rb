class GambitScheme < Formula
  desc "Implementation of the Scheme Language"
  homepage "https://gambitscheme.org/"
  url "https://github.com/gambit/gambit/archive/refs/tags/v4.9.7.tar.gz"
  sha256 "0da7c9772a2186dab1fba6bf6c777afe7424f40beacadf1b117d5cc825fe2db3"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "67a5f5bde73e525d2c488db0630747dd973391c70dca31856706a9406f63e9d2"
    sha256 arm64_sequoia: "d865948c300dca31a94bb7f6044abdf0c7b6b054c32fce1bbe20490d0956841c"
    sha256 arm64_sonoma:  "a50e4b0a899069f7e67a8cf47346bfcb80636b82d8af8d7a8cac989a6f1906f9"
    sha256 arm64_ventura: "2b0fabb679485de2ab986531dd750561969f8bad53397a60bf37804f389f7a09"
    sha256 sonoma:        "8a424288530b11d1e79006f4958683db02cb9070646697394ed3f12cc025a94f"
    sha256 ventura:       "731b5181b8d80d3a19ee3cb7a1d2f4a0eef9481940712a3926492462d8781262"
    sha256 arm64_linux:   "ecc701336f5dcd9619ce82abfc1ebac667a79c80ba9e9af5de2361f97befc613"
    sha256 x86_64_linux:  "32b5fa130a244ff8cc9dc13a27bfb30bd844ab21a3ec0f8f663f01a063d8351e"
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
      s.gsub! %r{/usr/local/opt/openssl(@\d(\.\d)?)?}, Formula["openssl@3"].opt_prefix
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
