class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "892f8c9918f887c8923c9bb939d251766f9e30cb436ff10db338871a66d81d10"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "7381b2ba1b0da43f90ec149fdf3bdb8d2d926999814abc5093d9673e67ee811c"
    sha256 arm64_ventura:  "487806f3b492544d592bb34ba2e0d464c1a02f1e825d84105ae69e8afa273f79"
    sha256 arm64_monterey: "bd6f2583f03c74f5520c5db7c4c6f4d19b0f9c7f6e2ff81232db7f78040ec110"
    sha256 sonoma:         "21d000dc9cb588226bde3a624721e33f2c7b5948e34acb8dba58258cc8dd5c39"
    sha256 ventura:        "6ce4c0087815a8557364637de7b6c7dad33970e89c66aa8f21ee4988468f8f6d"
    sha256 monterey:       "bc03881ead1c8516e73da0f6c262fb589d454567bd6919f4ca08e06ea0c8856f"
    sha256 x86_64_linux:   "1af44c6cd15affa6293d0cc63b722b3c70079687b9e1e0713761fb975523de66"
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
