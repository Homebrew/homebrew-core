class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se/"
  url "https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.1956.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/p/pike8.0/pike8.0_8.0.1956.orig.tar.gz"
  sha256 "6a0f2677eb579865321bd75118c638c335860157a420a96e52e2765513dad4c0"
  license any_of: ["GPL-2.0-only", "LGPL-2.1-only", "MPL-1.1"]

  livecheck do
    url "https://pike.lysator.liu.se/download/pub/pike/latest-stable/"
    regex(/href=.*?Pike[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "189339328f08b4736331e28f84a222c9bd77ee5f3d0742ddf4f5a8a4b153682f"
    sha256 arm64_sequoia: "75e3d156d755d9f21686a6a97f7abe5bab99543aed10c0bc9b1924b522a76be3"
    sha256 arm64_sonoma:  "aa0db19f0c8c530b0a2987a8e9109f59e912bed0e03230d648a6d5626b60f6f5"
    sha256 sonoma:        "23f03f540634e32d1d2daecd6b396753b133aeb78a6bddc1c8e8a01907068835"
    sha256 arm64_linux:   "4fff05c1bf9d0b62313086b0a50fdf8fad2cf794d27db659c3f87d3d22a8aff6"
    sha256 x86_64_linux:  "b657334fefce83ee4ce0a359c8eea9a8b2d5a07638bba4972a33f4fe6c9bf89b"
  end

  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "libtiff"
  depends_on "nettle"
  depends_on "webp"

  uses_from_macos "bzip2"
  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "gettext"
  end

  def install
    ENV.append "CFLAGS", "-m64" if !OS.linux? || Hardware::CPU.intel?
    ENV.deparallelize

    # Use GNU sed on macOS to avoid this build failure:
    # sed: RE error: illegal byte sequence
    # Reported upstream here: https://git.lysator.liu.se/pikelang/pike/-/issues/10082.
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    # clang: error: unsupported option '-mrdrnd' for target 'arm64-apple-darwin25.0.0'
    ENV["pike_cv_option_opt_rdrnd"] = "no" if Hardware::CPU.arm?

    configure_args = %W[
      --prefix=#{libexec}
      --with-abi=64
      --without-bundles
      --without-freetype
      --without-gdbm
      --without-libpcre
      --without-odbc
    ]

    system "make", "CONFIGUREARGS=#{configure_args.join(" ")}"
    system "make", "install", "INSTALLARGS=--traditional"

    bin.install_symlink libexec/"bin/pike"
    man1.install_symlink libexec/"share/man/man1/pike.1"
  end

  test do
    path = testpath/"test.pike"
    path.write <<~EOS
      int main() {
        for (int i=0; i<10; i++) { write("%d", i); }
        return 0;
      }
    EOS

    assert_equal "0123456789", shell_output("#{bin}/pike #{path}").strip
  end
end
