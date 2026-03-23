class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  sha256 "0f3152632a2a9ce066f20963e9bb40af7cf85b9b6c409ed892fd0676e84ecd12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "0cfc6f6aa9caa4d26566113476e9e6363a26728d4f23cfe7735f21f7ffb5383c"
    sha256 arm64_sequoia: "38948864d8d2bd66854fa4b9c7c912e62685add57394bb51f9ccaf876f4ecc39"
    sha256 arm64_sonoma:  "e74ca2c3523c847f358a4d98eec72c7b3bb4fbea7c3508ac78e3c25a5006099c"
    sha256 sonoma:        "bb8d99caaa6729636d012cf68a3819e7f8d86d0ba5d41be45e43481db9ba0a16"
    sha256 arm64_linux:   "9c8d7f64dedef7ee36b69aaaf0c0ece9d4a19e0a48a04ded9811d751c9e665c0"
    sha256 x86_64_linux:  "8a1e75510838008f58ce0dccbd0090a52c15a0afaec2f6534f557294a4aeada5"
  end

  depends_on "pkgconf" => :build
  # Requires the <uchar.h> header
  # https://sourceware.org/bugzilla/show_bug.cgi?id=31320
  depends_on macos: :ventura
  depends_on "zstd"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.cxx11

    # Avoid build failure: https://sourceware.org/bugzilla/show_bug.cgi?id=23424
    ENV.append "CXXFLAGS", "-Wno-c++11-narrowing"

    target = "arm-linux-gnueabihf"
    system "./configure", "--enable-deterministic-archives",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--disable-werror",
                          "--target=#{target}",
                          "--enable-gold=yes",
                          "--enable-ld=yes",
                          "--enable-interwork",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/arm-linux-gnueabihf-c++filt _Z1fv")
  end
end
