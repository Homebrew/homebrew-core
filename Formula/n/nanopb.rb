class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.1.tar.gz"
  sha256 "882cd8473ad932b24787e676a808e4fb29c12e086d20bcbfbacc66c183094b5c"
  license "Zlib"

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eeb572e24c3e2aa9c3790cd5892849c85ac5761d5001514c78da09db7fe8c8e9"
    sha256 cellar: :any,                 arm64_sonoma:  "44a773082a9f0593e9ebf2248d495d365551ee3639d40141145827890a96f28b"
    sha256 cellar: :any,                 arm64_ventura: "1841cac9c12b759afaf24dc8cfaa3b9b484947ecdbf7309a99bca1c1cbef6a75"
    sha256 cellar: :any,                 sonoma:        "80356a61ac01a070654c250384e8b55366cf15294e28fe9a7f0773b0a1fac312"
    sha256 cellar: :any,                 ventura:       "7952caaab0773710a097a4004b8bd5e6c31848f75bd743eb67100e3e1c0ec586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1b933e606270d4d4227c032e1b078b508288a4af7f423b9f6eced525f48696a"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.13"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/6a/bb/8e59a30b83102a37d24f907f417febb58e5f544d4f124dd1edcd12e078bf/protobuf-5.29.0.tar.gz"
    sha256 "445a0c02483869ed8513a585d80020d012c6dc60075f96fa0563a724987b1001"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
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
    (testpath/"test.proto").write <<~PROTO
      syntax = "proto2";

      message Test {
        required string test_field = 1;
      }
    PROTO

    system Formula["protobuf"].bin/"protoc",
      "--proto_path=#{testpath}", "--plugin=#{bin}/protoc-gen-nanopb",
      "--nanopb_out=#{testpath}", testpath/"test.proto"
    system "grep", "Test", testpath/"test.pb.c"
    system "grep", "Test", testpath/"test.pb.h"
  end
end
