class Baresip < Formula
  desc "Modular SIP useragent"
  homepage "https://github.com/baresip/baresip"
  url "https://github.com/baresip/baresip/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "2b03fbbdb59ac1de91c0264ebb7256886c298e9efe0bcb0b9514ea00a4d48f40"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "d12c8aded909e00461d92323d80e5fdda1d52f7f5758ce62258026f295bc6285"
    sha256 arm64_ventura:  "453c0eeac3cc567a29e51ab98cb448245190aa609c4d4ce5a4d02fd692836a03"
    sha256 arm64_monterey: "1cc2cd80b5c31235107a69160fbe142a616615dee294b8c3fc69de5ed7bca6b3"
    sha256 sonoma:         "19544296f378e5295f5b6bbdd722f3d65c63da0215adcbb720315c6e0e87cc99"
    sha256 ventura:        "6d5597cb5cae200f93147bd0f335bcc299ea242632e6b1923b335e61cd196720"
    sha256 monterey:       "33d5fdef21463700cb0c6362c89dff7ffdda4027b5b29eabf7fce3113faa47fb"
    sha256 x86_64_linux:   "f9132ddc60d97b40bcdc56e382080b9c4fdaa5dc70a84aa038083f265db9440b"
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
