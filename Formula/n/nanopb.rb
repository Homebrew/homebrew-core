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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "9e0cb50940e2d1d1212a062b35b802435230fef6e1129b871433d1a28a3d0241"
    sha256 cellar: :any,                 arm64_sequoia: "8e5fc9b388c93d9b3a7e1bd78fbda89bbc5599160f000068707635f6bf2c214f"
    sha256 cellar: :any,                 arm64_sonoma:  "ab9ee42905d4326caf3e9d9c077e097f5f411d9ef9757026475f8053a3ee2eaa"
    sha256 cellar: :any,                 sonoma:        "c534620822741f208cbb0bbe2ef3e6451e9411bb9972e66083f684f6dc0ab6fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1423f4ce72738f08682ae0e3e89ab6725dda1a2ff08353520152d7c4535a5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba95c5b31f0fc537bb430bd5a62d0421a77dcd84e04c12a438b4ef25cb641b56"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.14"

  pypi_packages package_name:   "nanopb",
                extra_packages: "setuptools"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/fa/a4/cc17347aa2897568beece2e674674359f911d6fe21b0b8d6268cd42727ac/protobuf-6.32.1.tar.gz"
    sha256 "ee2469e4a021474ab9baafea6cd070e5bf27c7d29433504ddea1a4ee5850f68d"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  def install
    ENV.append_to_cflags "-DPB_ENABLE_MALLOC=1"
    venv = virtualenv_create(libexec, "python3.14")
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
