class Nanopb < Formula
  include Language::Python::Shebang

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.8.tar.gz"
  sha256 "d685e05fc6e56fd7e4e3cacc71f45bd91d90c0455257603ed98a39d2b0f1dd4b"
  license "Zlib"

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6aafd959d5a55d12adf57deef047fa9d3fde83706d1cadaa3a80ea82941c9984"
    sha256 cellar: :any,                 arm64_ventura:  "27001fa186f02615caffd3426000673438f9b0a045cacb644d963650f6838cfa"
    sha256 cellar: :any,                 arm64_monterey: "f05782e62c16bf7af01471fd2c5fe4564c8f7a0f4a1ecc3b2f819faae109c52e"
    sha256 cellar: :any,                 sonoma:         "4e3053cca4d1cd7f16a0be1d134d0c433505995b4462818274fd1f0a080ec77c"
    sha256 cellar: :any,                 ventura:        "fa97d9a613f75b52c8b9925446f06997a541a1804997682eec9d84f7b76c6aca"
    sha256 cellar: :any,                 monterey:       "fb0da4501ea92c1524411a23f5d7622050dcd377296e4f3b5d7755fdf2f76fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3be96c45fc2ac7c8b463295a9ba2ab0aa137f842cd08822eda17b727b43ae886"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python-setuptools" # import pkg_resources
  depends_on "python@3.12"

  def install
    ENV.append_to_cflags "-DPB_ENABLE_MALLOC=1"
    site_packages = Language::Python.site_packages("python3.12")

    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-Dnanopb_PYTHON_INSTDIR_OVERRIDE=#{prefix/site_packages}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    rewrite_shebang detected_python_shebang, *bin.children
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
