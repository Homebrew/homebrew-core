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
    sha256 cellar: :any,                 arm64_sequoia: "e565dfe652e29a83bafdb07c65f79ae1c6eec3481b38c16cb19e05d6b0474129"
    sha256 cellar: :any,                 arm64_sonoma:  "e4bababae240e00a31b80d33ca35435ba367a4e8058fc2a15c07ab4f5b416cc0"
    sha256 cellar: :any,                 arm64_ventura: "cca3662f717c4a90c24a8e2bd8ef214a884d2023ae5844630adbfa27b2c4543e"
    sha256 cellar: :any,                 sonoma:        "a6ffcad93f6e937b070e8abf4a30128ef1ab66f7a44a111c9c39696488d06fe0"
    sha256 cellar: :any,                 ventura:       "132d3b26b75e83e90b0799cc1180adf89b603d3a35f73683eca7bd54df8cf15f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b71c7cdc6bd1c8f1eccb7b123c47e1e56cd6ea8471eecebc8c3dfce29ed16e2a"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.12"

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
    venv = virtualenv_create(libexec, "python3.12")
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
