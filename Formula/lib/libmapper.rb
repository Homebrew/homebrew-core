class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://github.com/libmapper/libmapper/releases/download/2.4.4/libmapper-2.4.4.tar.gz"
  sha256 "2204f610f6a3eff4f66cb866101c3cda911a5e5a9fe04b518a0a99608a8473ff"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "35cfd6a1ebeb7b1972ba02e2a72ebced311ca8105c1578cfd6430f4b39b63143"
    sha256 cellar: :any,                 arm64_monterey: "f376d8f2b23d4a31021455cc5bccb4eb5a18680bba3cc005735dda8240800dd0"
    sha256 cellar: :any,                 arm64_big_sur:  "fac6bccd4981c29700fa149986fd16c72a7abfef4afe263ae8a25fe731df123a"
    sha256 cellar: :any,                 ventura:        "c3f5d81edf4cc1fb4445c7cb97d5eb712f1b82d8e537afbbd37c167c0ffe39d4"
    sha256 cellar: :any,                 monterey:       "96e34dcaee6d6d07e05bca570aefe3601ad8c24e6d850258f21aaf7144529b2a"
    sha256 cellar: :any,                 big_sur:        "5affd8c13da08159d12f496a6abe4ce7d4900cb2d3d21a25ddee94a59009fe73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "089ec04b44e1bd620ac7e68c60c6c31a0367b5daeb80e0d9fe389ba0c18aa3cd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "liblo"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "mapper/mapper.h"
      int main() {
        printf("%s", mpr_get_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmapper", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
