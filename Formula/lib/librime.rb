class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.13.1",
      revision: "1c23358157934bd6e6d6981f0c0164f05393b497"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cf413846de5257ed69c635bda821c97ad3a36ced35142c3f6fafd60900870b6b"
    sha256 cellar: :any,                 arm64_sonoma:  "a0f8ec80406b78209f9796a65364590f81620323b8068af4ad6a1af37e390656"
    sha256 cellar: :any,                 arm64_ventura: "88ab106ef147e60b6f4d8220d0662891819da6209f0d1e9e02360f7095345669"
    sha256 cellar: :any,                 sonoma:        "945951fb791064e11b3889224ecb58c92f7eddd103034d444263dfe3a74a698a"
    sha256 cellar: :any,                 ventura:       "74a5240d68f3b45727523df8c4f469f95aa6aab40ef8f39dbdd201bf1f5b8614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa93377e6691b4d4d6a323beda9f27381d5b7f805a0a21287a4d42fccbd1a9bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa8f6a3c5c42fbf14423d398f68eb17dc40cc43615e815c763ee97b31bb9c828"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@77" => :build
  depends_on "pkgconf" => :build

  depends_on "capnp"
  depends_on "gflags"
  depends_on "glog"
  depends_on "leveldb"
  depends_on "lua"
  depends_on "marisa"
  depends_on "opencc"
  depends_on "yaml-cpp"

  resource "lua" do
    url "https://github.com/hchunhui/librime-lua.git",
        revision: "e3912a4b3ac2c202d89face3fef3d41eb1d7fcd6"
  end

  resource "octagram" do
    url "https://github.com/lotem/librime-octagram.git",
        revision: "dfcc15115788c828d9dd7b4bff68067d3ce2ffb8"
  end

  resource "predict" do
    url "https://github.com/rime/librime-predict.git",
        revision: "920bd41ebf6f9bf6855d14fbe80212e54e749791"
  end

  resource "proto" do
    url "https://github.com/lotem/librime-proto.git",
        revision: "657a923cd4c333e681dc943e6894e6f6d42d25b4"
  end

  def install
    resources.each do |r|
      r.stage buildpath/"plugins"/r.name
    end

    args = %W[
      -DBUILD_MERGED_PLUGINS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_EXTERNAL_PLUGINS=ON
      -DBUILD_TEST=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "rime_api.h"

      int main(void)
      {
        RIME_STRUCT(RimeTraits, rime_traits);
        return 0;
      }
    CPP

    system ENV.cc, "./test.cpp", "-o", "test"
    system testpath/"test"
  end
end
