class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.47.tar.bz2"
  sha256 "3068128c75cda9f898ccb4211d360246e8e195ffcc9dfb655b23ae23a54800e8"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "114e1c97a10416e088ecfaf59a7e6095208dca721aebdda8848177a1eabe9b74"
    sha256 arm64_sequoia: "d34613b52d6b8bc65f76c09be800faebf796a6556ee1e246760b05fcc6873e16"
    sha256 arm64_sonoma:  "d2c43c3f06581bfea4dbc6c16bb2303bbc9fa2f2a4b534e6ccd2fb1509849d29"
    sha256 sonoma:        "383da8b87381b3540d0dcf4aa373ba1afe403ee1dfe4eab8dc38d626a3aaddb9"
    sha256 arm64_linux:   "c985f45b7b788c587a9f275626c5d3fe75ca53bd2f4b4368dec88ef1b78147a2"
    sha256 x86_64_linux:  "69aa4791d3fb0b900de1f0e7cfccd0427b2cb3e3b7ddba27bacf67937bd28dba"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_macos do
    # Requires the <uchar.h> header
    # https://sourceware.org/bugzilla/show_bug.cgi?id=31320
    depends_on macos: :ventura
  end

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
                          "--infodir=#{info}/#{target}",
                          "--disable-werror",
                          "--target=#{target}",
                          "--enable-gold=yes",
                          "--enable-ld=yes",
                          "--enable-interwork",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls",
                          *std_configure_args(libdir: lib/target)
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/arm-linux-gnueabihf-c++filt _Z1fv")
  end
end
