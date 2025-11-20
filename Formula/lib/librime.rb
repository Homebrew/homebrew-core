class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.14.0",
      revision: "e053fb29e4a7c584d93c81e2e314bc1c9efca0a6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f30fc8c4a91b6d4cd7c03d7be232e34f518ab856dd2d1723a939ff3a4d3a09da"
    sha256 cellar: :any,                 arm64_sequoia: "1adf609bd7d7fbdefdc4c61f22286353bc58e3ccaa37f017d4a95d9fdcb682c1"
    sha256 cellar: :any,                 arm64_sonoma:  "14d9f57764a6b5a0d53c7f3873be7662b7c165f573094860fb40623cd0691857"
    sha256 cellar: :any,                 arm64_ventura: "6e45c1b22aaa6aceb263b1193c2da3f8abaaf1d7ef1a024616f12baf052e02dd"
    sha256 cellar: :any,                 sonoma:        "d29dc1c67f9718755b41cd7c6468635b8c84e9c1139be79b5da2210bf95cf7e6"
    sha256 cellar: :any,                 ventura:       "fb36ab6bfc5025f2094a4c79635ab3e1c3c79b377382dd1c0253eed5c67467c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "593b69d2cd6eb87d1ce411007bfd7cd8b28e28c4e04c3d0e19c657becd9ec2be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1fbfebca1dd86132c8420fc30d41c44728371a473c6ae4e608d82cf7a7d27cd"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "icu4c@78" => :build
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
        revision: "68f9c364a2d25a04c7d4794981d7c796b05ab627"
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
