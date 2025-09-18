class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "ef8663b95caf187edd5062136230be02bd6815090da410b2fe6b7e1341312133"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_tahoe:   "95a477fd94100e3f71fc1be5287199a52bbc92f8e3ff5ebd0c822a9b05d36a58"
    sha256 arm64_sequoia: "a2b6c693b6bb0cb0daa6eaf6e6fd03ff995b5a92b68e8c64214d9d0c21fe09bb"
    sha256 arm64_sonoma:  "9e7e2b886cf6d1f1795c4a5261873e1445a53a035768a305863f2cc0a22e2a53"
    sha256 arm64_ventura: "74252e2e7376beda580b0dc7b03c05dfc9051577de90c14f7e5973e9422b2905"
    sha256 sonoma:        "5d693db228ff680c5325d4db4e43049e388119b0a870262c0869b5922d09a3cd"
    sha256 ventura:       "c7d3825e51144f7e82fe6d20b508393daf504dfc124e621fafb3333885423749"
    sha256 arm64_linux:   "944b1b684ddcaf67a9c9fa95878c117c8b9b626aef3f73872af62480f3b34adb"
    sha256 x86_64_linux:  "ca594150a1206512391b655f494a1a474bc803f4d129410b2d39d4d4c57a47fc"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{Formula["libre"].opt_include}/re
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
