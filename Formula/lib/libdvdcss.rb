class Libdvdcss < Formula
  desc "Access DVDs as block devices without the decryption"
  homepage "https://www.videolan.org/developers/libdvdcss.html"
  url "https://download.videolan.org/pub/videolan/libdvdcss/1.5.0/libdvdcss-1.5.0.tar.xz"
  sha256 "529463e4d1befef82e5c6e470db7661a2db0343e092a2fb0d6c037cab8a5c399"
  license "GPL-2.0-or-later"
  head "https://code.videolan.org/videolan/libdvdcss.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/libdvdcss/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a5d4c6891b5f9fb44fe66d4ab1317be59dbf8aa9ceb33c6f05b5952547705d0b"
    sha256 cellar: :any,                 arm64_sequoia: "1aebedeb3811f84a19a05160321eada6ca39130948428e4e0a8af6d2ca6f7c37"
    sha256 cellar: :any,                 arm64_sonoma:  "c80a83c521635f153f1fc27bc1dfca7651d49c74bc76f449e325f058b898fa47"
    sha256 cellar: :any,                 sonoma:        "5223d1869afb3e6d00535d49c83eb5c78eef6173fdd9d15c137d6452d9aa6516"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd4ba20cd9a543abf5e6fa9780d535c9ad4751b0ee39464cbb73c0c1f00d6877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29d4fd7b31ac1726a8778e1c010f6cc0a16c2170263c4932f59b619ec728ca83"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dvdcss/version.h>
      #include <stdio.h>

      int main(int argc, char** argv) {
        printf("%s\\n", DVDCSS_VERSION_STRING);
        return 0;
      }
    C

    pkg_config_flags = shell_output("pkgconf --cflags --libs libdvdcss").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
