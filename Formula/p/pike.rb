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
    sha256 arm64_tahoe:   "0c0dbf05213979a83add31b2d9c0983fbaeda715b9d644886ae523e6da58524f"
    sha256 arm64_sequoia: "1f3675eb394156e536145ea57151f73999675893f4827358673338d31e5dd044"
    sha256 arm64_sonoma:  "86a5d508ea7ef36bc6c160adce3672556ca34b0f636227cc78fb69b1ebe69579"
    sha256 arm64_ventura: "6b6f4b66d20a1d4f0d12955f939280a02635e8c459d803ae90ba900d9b3d2401"
    sha256 sonoma:        "3020a095c90dea0257703d3c47f594c5c9d136655469d57e369d9e89daf3fe97"
    sha256 ventura:       "6cbd38e90fd0f66a8e87e084e7b78a659cf8e27c9b6f5e3ab001bdec2bd72656"
    sha256 arm64_linux:   "d508b63e39b6dc8e7be55395dc1a87dfc1da292ddc638a254b49c0bd7052887d"
    sha256 x86_64_linux:  "59dae235eeb446e2a34bcf99aa113b9571bb012f4559e44b973d2fbbd6d40832"
  end

  depends_on "gettext"
  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "libtiff"
  depends_on "nettle"
  depends_on "pcre"
  depends_on "webp"

  uses_from_macos "bzip2"
  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "libnsl"
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
