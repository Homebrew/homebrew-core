class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.1.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.1.tar.bz2"
  sha256 "becaac5d295e037587b63a42fad57fe3d9d7b83f478eb24b67f9eec5d0f1872f"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_sequoia: "6942fe8a2cb9b5bf36dc3af17b5e0eaf7646c843fe599f924fe7ab8c1d31da6c"
    sha256 arm64_sonoma:  "fc58d0db195365cfbae0778ddb159b972bba0f8025a4748d6a622b27b36a4a37"
    sha256 arm64_ventura: "4b4b2e940fd37153d23adbe7a05fe7c191232cff01ed6fa7545e2ac4018c2ca1"
    sha256 sonoma:        "14d772054e88d8a57c6f6d96968866130d49943bc72e4943198a988b8c4deab7"
    sha256 ventura:       "2c8df1295a2dd0f809e069198378358caacd8688d180917d5216c2bda0dbb86c"
    sha256 x86_64_linux:  "6dca015b099d6221e09b9acfba7514099d538d5bf57fa5b40940a7bf1bb256be"
  end

  depends_on "pkg-config" => :build
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
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--disable-werror",
                          "--target=#{target}",
                          "--enable-gold=yes",
                          "--enable-ld=yes",
                          "--enable-interwork",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/arm-linux-gnueabihf-c++filt _Z1fv")
  end
end
