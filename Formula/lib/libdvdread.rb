class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  url "https://download.videolan.org/pub/videolan/libdvdread/7.1.1/libdvdread-7.1.1.tar.xz"
  sha256 "a0d47876548bec806774bbf8dbf20bb19ba139464383156b32eb8e59915b90a9"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://code.videolan.org/videolan/libdvdread.git", branch: "master"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libdvdread/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "307eb729e84b937f6c3a690f2c94c42d6c18f5cf87ae525a57289f34f40086eb"
    sha256 cellar: :any, arm64_sequoia: "791120e7de056e453ec17e3ddfeb574f9601d9a65cfce3b7d16a6450173956f1"
    sha256 cellar: :any, arm64_sonoma:  "f82a015ef53dd2f0b90c28cf9f59c894fa254ce1e8d2c381e85040d4edfd82f3"
    sha256 cellar: :any, sonoma:        "0aab2e5327c22ef12679f0d58b933607cfd153f1c06904c6290c07c6bb96d250"
    sha256               arm64_linux:   "6a860730dd7b8d385120f37beb2663826c37d39b94773e2537867b6c18a51f1b"
    sha256               x86_64_linux:  "e51bd831a7f12a02c5c2ecea4a656424735f2e19438ff08d1026fe6cb97cacf6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libdvdcss"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dvdread/version.h>
      #include <stdio.h>

      int main(int argc, char** argv) {
        printf("%s\\n", DVDREAD_VERSION_STRING);
        return 0;
      }
    C

    pkg_config_flags = shell_output("pkgconf --cflags --libs dvdread").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
