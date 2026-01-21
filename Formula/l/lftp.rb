class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://github.com/lavv17/lftp/releases/download/v4.9.3/lftp-4.9.3.tar.gz"
  sha256 "68116cc184ab660a78a4cef323491e89909e5643b59c7b5f0a14f7c2b20e0a29"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "7fb1f7e9e672a8299dfd17a230ad0625fc3b7eb5ef5be73a0efbb6635ca6315b"
    sha256 arm64_sequoia: "275b333b0e01dc1bc87f11332d5ee33d1399d73f36e3123f97a7a16d229c5d37"
    sha256 arm64_sonoma:  "91e89854b82451fcd1dc6bfb2182b344adec778d5951224242aee4de60324034"
    sha256 arm64_ventura: "47191323a1e714ea7534413bdc8d4dc90960cebe01cd634c85f44d100790c438"
    sha256 sonoma:        "e4cb328becffa3416e370bd627bbea0e29505fe162f3d1c4ff54ad1da50ebb3b"
    sha256 ventura:       "91432c67fc43b779976229a1c2982e4cfa32cff893d68cfe0e382fd175259ea3"
    sha256 arm64_linux:   "ad07c842761f21a2452fe69d76b1212725274ce09df5061bacd09ac77667b6b5"
    sha256 x86_64_linux:  "a4b7a6b989cdc30e9f5070e0d3669e2717e53b13984aef179035b99f0e2c2ab6"
  end

  depends_on "libidn2"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    # https://github.com/lavv17/lftp/issues/611
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1200

    system "./configure", "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn2=#{Formula["libidn2"].opt_prefix}",
                          *std_configure_args

    system "make", "install"
  end

  test do
    system bin/"lftp", "-c", "open https://ftpmirror.gnu.org/; ls"
  end
end
