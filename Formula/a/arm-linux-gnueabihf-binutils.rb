class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.bz2"
  sha256 "860daddec9085cb4011279136fc8ad29eb533e9446d7524af7f517dd18f00224"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "5759b6b7666b3a04467b9bf8c62393a3d9ead647b2073a4f17699d889a6b0702"
    sha256 arm64_sequoia: "bfc25771adb53a9cf8a731d01ee1b07b955c6682f942c9a9b0e3c8e65688a3f0"
    sha256 arm64_sonoma:  "731ce8146c4968ff23eacc25e88a4313b753e8d5e61dca54f4260ab085fa436a"
    sha256 sonoma:        "793f5765cdc8552d31c25ca65ae6726aa4ad63ec1eaccddc75f77169b4aa1cae"
    sha256 arm64_linux:   "6577631a8d78290dd346a28b760d3e9347d7e8dd9a0bbc075ecf82a7cb5c06aa"
    sha256 x86_64_linux:  "eab2d6ae6e004d16aec1fc282483606895e193c5888ac0e988c1504e1610bb58"
  end

  depends_on "pkgconf" => :build
  # Requires the <uchar.h> header
  # https://sourceware.org/bugzilla/show_bug.cgi?id=31320
  depends_on macos: :ventura
  depends_on "zstd"

  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
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
