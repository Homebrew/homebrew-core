class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.9.2.tar.xz"
  sha256 "c517c4f4f9c39bd415d7313088a2b1e313b2d386867fe40b7692b83a20f0670d"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://github.com/lavv17/lftp.git"
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "aaff61c7beb8135dfd9888ac0e7fbde05a83b3189f5610a682ed01bde537f16a"
    sha256 arm64_ventura:  "c9bb0571b5b9472a289e93b9210e1917bede06a2d5909d47eacefb0f2f042439"
    sha256 arm64_monterey: "d3d9dd22c527c2e7b97f6972a3e902ae58dbd52cac41a9f5480e350bc00cfb79"
    sha256 arm64_big_sur:  "5df3fa7301a808e6f0194c833ff4a1003ad912f6524f4b79d175f2fd727a5883"
    sha256 sonoma:         "48af9632ac3e06f2d8f65477ab05c2e57303561cc2f14c185154d069b21326d5"
    sha256 ventura:        "dcb1fb4a543b3bd88b915ab1b616e42a8ef821d7987cd54bfcedb8436ff3e4a4"
    sha256 monterey:       "ea4d5856758cd68e0a71606513352159c0e35fc97dbb07db747f2709b411787c"
    sha256 big_sur:        "f51859af8603b65107fadf56c429a7f9582d7a1b232283c31a9d7933bf3306bd"
    sha256 catalina:       "a35a9903b86843178a558fe72cc83f66d7821843cd43ab3580d915b165b0d383"
    sha256 x86_64_linux:   "af84a1995e2213553c91e78b746cf9c921a11fa99bffcaea96f842669e956c81"
  end

  depends_on "libidn2"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "zlib"

  def install
    # Work around "error: no member named 'fpclassify' in the global namespace"
    if OS.mac? && MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    # Fix compile with newer Clang
    # https://github.com/lavv17/lftp/issues/611
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn2=#{Formula["libidn2"].opt_prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open https://ftp.gnu.org/; ls"
  end
end
