class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.1.tar.gz"
  sha256 "882cd8473ad932b24787e676a808e4fb29c12e086d20bcbfbacc66c183094b5c"
  license "Zlib"
  revision 3

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "d2b3e4f7a291d667e54ffc6c2ff6b317a3dcfa9b32b830206f2c9d078d86a150"
    sha256 cellar: :any,                 arm64_sequoia: "ecb816f68b51bbaebabfaf9b4f502a0db3ca799a3e0c5f413cd2f5bcfc0decfa"
    sha256 cellar: :any,                 arm64_sonoma:  "656534571186e6f68cb4cf2198c63918abd46e610156a3e71c4f7682a3fc0b0d"
    sha256 cellar: :any,                 arm64_ventura: "31af3f51d7520ed6792329f69a72e016aa7a0c64d1d3ef82ed16757d86dfd0ce"
    sha256 cellar: :any,                 sonoma:        "d70946b2dc480f133703be76c9ba815e29a6b8675cd60933ada303981b0c285f"
    sha256 cellar: :any,                 ventura:       "5c89d326dba83eb21fe7673af64d381a1a7a62af08c519916b8857767c4eef52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa969f7baad5137162f601a3284ead910e25e1a1416da412a35a8da8d5a4cc5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c334dde1990778c6e54eb2e4fb012e7d8aa88d0e365a6beaaae9d7ebad89a9e8"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.13"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/c0/df/fb4a8eeea482eca989b51cffd274aac2ee24e825f0bf3cbce5281fa1567b/protobuf-6.32.0.tar.gz"
    sha256 "a81439049127067fc49ec1d36e25c6ee1d1a2b7be930675f919258d03c04e7d2"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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

    system Formula["protobuf"].bin/"protoc", "--proto_path=#{testpath}",
                                             "--plugin=#{bin}/protoc-gen-nanopb",
                                             "--nanopb_out=#{testpath}",
                                             testpath/"test.proto"
    assert_match "Test", (testpath/"test.pb.c").read
    assert_match "Test", (testpath/"test.pb.h").read
  end
end
