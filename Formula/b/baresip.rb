class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "52b7544a3a2a152c36010897617512ab0a9e24f81db32fdba30be9b7430373d2"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "6d07d04184ffb87ee5839acccf444cd10222fa678e23d95f632432981aab5ee3"
    sha256 arm64_ventura:  "9c61ff67d050ceaa9b686a346d06e76e9e75549b1ec0f12a024dd38c7633102c"
    sha256 arm64_monterey: "e44bd1185895d8057b2bc4b1f03e31643ca8961729a8e0ddda1167e9e04a1a30"
    sha256 sonoma:         "96470ce8d910779f62f6da357ad3711f7247df50d549c067d5800ab2c8fb1070"
    sha256 ventura:        "4ef0cc7ea54235856965a7d0c4a97070a1ab8ff6c8993de5c077293f9c2eedd7"
    sha256 monterey:       "861e6e7ab64de22fcfeb0de094a9518a27275b964b9dd15b3f7de3b35e585b5c"
    sha256 x86_64_linux:   "4812bade9b20bf338497e1c49cc6ee12c01bae26ea0ba9cfc35c8638c3509292"
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
