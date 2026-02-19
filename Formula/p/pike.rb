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
    rebuild 2
    sha256 arm64_tahoe:   "fcdd576e2d1f6a9e6e5950e606961b3e2a3342470498789089e279a5d3674be4"
    sha256 arm64_sequoia: "6555f68623b88de4cbd0b3f79fc8cbe809fc7752f866c74a5daf9df5bbdfffc1"
    sha256 arm64_sonoma:  "40d3f38c11347d04b10d29c5a9494a8b95d2b99fb666e18c436b36c995a77661"
    sha256 sonoma:        "a85dee58bfc10160afc4d814cc7665837c404861a2f8ba64df76923835868e16"
    sha256 arm64_linux:   "9ca8feac2ad91ed44254a1acba6316c24459cc5f0f750727d33e814cd2ee07ab"
    sha256 x86_64_linux:  "d4c545ecc893e81fbde64c012b73d405749254ff6a5f9feab5ac608cce09390b"
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

  on_macos do
    depends_on "gnu-sed" => :build
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
