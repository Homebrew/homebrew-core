class Librime < Formula
  desc "Rime Input Method Engine"
  homepage "https://rime.im"
  url "https://github.com/rime/librime.git",
      tag:      "1.13.1",
      revision: "1c23358157934bd6e6d6981f0c0164f05393b497"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6950499f52c75ae9a9c59a7b1c710590963229860ba072a29bc856ae4ef29f1a"
    sha256 cellar: :any,                 arm64_sonoma:  "752f1dc2084618b465a2f000213c0da2ded44e1d5bb44bfe8e1c18934b5ee359"
    sha256 cellar: :any,                 arm64_ventura: "bc4d9d173e73fe33f15bc47badbc380c0ea5926e134c9dbd23cfe4c845781d0d"
    sha256 cellar: :any,                 sonoma:        "4aa81809e4fec4fd278e6429bab0d478bcc5544c958897c491391367e4ddfc8e"
    sha256 cellar: :any,                 ventura:       "9199881c5f61ac797c9c217b957f0845b00f15f1489fddf6a3ed2689b83c73af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "362ab72184aa3cdef179d8fe7ef89083b0b34872c9416ec65fe1999e386bd9ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3010ba31f95bf8a53ab4c56b96056d8265a443accbbda1f41c74e490c95fef04"
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
