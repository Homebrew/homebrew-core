class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "784dceac625094367a8d4983ca1e432e51742d614e1be8e75ab3d1804bdaa80d"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_ventura:  "143a4140cefd1ae972cd4613b67842c304b1d0824bdb1eb514bb55b293369c6c"
    sha256 arm64_monterey: "0e5ba17ba6284d947b3889c832141c9d3e1012320def7f8baa88ff87b401a0ab"
    sha256 arm64_big_sur:  "e4f2f639e7200954de9f3363d861d4c4795b2042175e4d240311fa69eb454233"
    sha256 ventura:        "42f62b96b58e5bc0c4124abeab97b8ab5e3f9582f3ebb60cc31fffb6706b3a25"
    sha256 monterey:       "14e80778bd6089f718d6ff248782153a3241b04e2c8dcf371bc6b3f678b9758f"
    sha256 big_sur:        "4b3801176016f45dc1c46fd571fc81ef6ef531f2365db2c85394b0150eda7bb8"
    sha256 x86_64_linux:   "1d1ae88fca25da68ccb3437cb285c5950ecef050a5402fb0d47c6b6da2be7402"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"
  depends_on "librem"

  def install
    libre = Formula["libre"]
    librem = Formula["librem"]
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}/re
      -DREM_INCLUDE_DIR=#{librem.opt_include}/rem
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
