class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se/"
  url "https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.1956.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/p/pike8.0/pike8.0_8.0.1956.orig.tar.gz"
  sha256 "6a0f2677eb579865321bd75118c638c335860157a420a96e52e2765513dad4c0"
  license any_of: ["GPL-2.0-only", "LGPL-2.1-only", "MPL-1.1"]
  revision 1

  livecheck do
    url "https://pike.lysator.liu.se/download/pub/pike/latest-stable/"
    regex(/href=.*?Pike[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ce99d1862387995d645b98b72e8704350c594f195ba0bae38e1b5f05aadd0fb0"
    sha256 arm64_sequoia: "268dff89f0555fb7cdbcaa8e0fc48ff02325d0b174ac540859b540c7a802eb94"
    sha256 arm64_sonoma:  "baefe332ca33ef1b915c7b34881586b8681279acc47e645126d4629df1212911"
    sha256 sonoma:        "bf5ba584a6a0c2b013f22b4b13c7d09285503f27a343400c7036001f914b3a02"
    sha256 arm64_linux:   "416e9e7fb333941f6c8c234a34d3fe9d9359b59525b53c26757ad5b6cdeae59f"
    sha256 x86_64_linux:  "9f54cedbb927f268a2c63563962ae27533deadf7f00ae636804491f948abca5d"
  end

  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "libtiff"
  depends_on "nettle@3"
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
