class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "bb886c393d29e6bb5f89395cff1985ba9eda27dfd3aac2a5221ef7957c44b1a1"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "3394e6520c23b01652d969176507b5cba99d17a7bd5556b0e3048029ccaa63c1"
    sha256 arm64_ventura:  "773ea68041dda36b728a181d2f1a0b2fcc5109c98feafa60ee737a61713d2c3c"
    sha256 arm64_monterey: "0619cfdaa9bf64d0071b22074731e03500daca806bf25d24d24712473ca873f9"
    sha256 sonoma:         "1610c2cb67eebf584100e3bf3980e64beae5855e3f5ec371b3d76cabeef8e42f"
    sha256 ventura:        "855c17b2e2f171013253037151884283f4dfb47103bbb7730825437e9eed13d7"
    sha256 monterey:       "f7c0e3ee97c3836afdb9de77186403ef0e03f016cf472d4980ad403efb887e01"
    sha256 x86_64_linux:   "c777d5fb1332a7a0344cfbbf50b4f9715002b1f219256937d907b627de560110"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libre"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    libre = Formula["libre"]
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DRE_INCLUDE_DIR=#{libre.opt_include}/re
    ]
    system "cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build", "-j"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"baresip", "-f", testpath/".baresip", "-t", "5"
  end
end
