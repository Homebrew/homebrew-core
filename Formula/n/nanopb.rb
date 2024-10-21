class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.tar.gz"
  sha256 "096a12331959590f5879f1039b2b6e32c887be58069e3bf1589aee949a420f51"
  license "Zlib"

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "4dda74ced165d82abc82f13baeb15b9d3598560c09b81587f185ff9f869b9718"
    sha256 cellar: :any,                 arm64_sonoma:  "324320a06e3f779104b027145321c2fc4bbbd879bceaf658f327e98e4f689a32"
    sha256 cellar: :any,                 arm64_ventura: "295498441bcdf15eb3aa2e231465426e0980c825ba59927a0cda38de0b6e0df2"
    sha256 cellar: :any,                 sonoma:        "3a2ea4468b72031cf014fe96b9f639328b4e4fcdacc8f8c3e6f94e93bafd4f8a"
    sha256 cellar: :any,                 ventura:       "2aba3891f33fc2ea0bf95d9394d6dcb82335e2707fda6c266416ea3efa45146d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d387808781feaf19ad9514de2bba60e7833af33ea648cd9d40458d84ddaa55b6"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.13"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/b1/a4/4579a61de526e19005ceeb93e478b61d77aa38c8a85ad958ff16a9906549/protobuf-5.28.2.tar.gz"
    sha256 "59379674ff119717404f7454647913787034f03fe7049cbef1d74a97bb4593f0"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/b8/f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74b/setuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  def install
    ENV.append_to_cflags "-DPB_ENABLE_MALLOC=1"
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-Dnanopb_PYTHON_INSTDIR_OVERRIDE=#{venv.site_packages}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto2";

      message Test {
        required string test_field = 1;
      }
    EOS

    system Formula["protobuf"].bin/"protoc",
      "--proto_path=#{testpath}", "--plugin=#{bin}/protoc-gen-nanopb",
      "--nanopb_out=#{testpath}", testpath/"test.proto"
    system "grep", "Test", testpath/"test.pb.c"
    system "grep", "Test", testpath/"test.pb.h"
  end
end
