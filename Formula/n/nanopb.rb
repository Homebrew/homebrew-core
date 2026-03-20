class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.1.tar.gz"
  sha256 "882cd8473ad932b24787e676a808e4fb29c12e086d20bcbfbacc66c183094b5c"
  license "Zlib"
  revision 6

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "51fdb8214773b1431f5f54eb3bb94d583140a2af0aa5d13ba4a7d9a95a175ffe"
    sha256 cellar: :any,                 arm64_sequoia: "b1a79bde77a10714cd34a651d38323804b6ace9c4882469e8eeff447bd527981"
    sha256 cellar: :any,                 arm64_sonoma:  "cd834785baaa72e3e9cdff0d38c25eeace2f145df358cea150e379121bffba43"
    sha256 cellar: :any,                 sonoma:        "24be4b707a3495e707546c5fefb63394c666a8562241c77dcce69942937b2648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e9954ea9fa95369fd9f1685dff2f75e0a14b8c65a1d7f0519dcbd3651a08f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3c0b0233455e0d27ab4a16291f6db79aa1f256b28e419cba62cfbf159361319"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.14"

  pypi_packages package_name: "nanopb"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/f2/00/04a2ab36b70a52d0356852979e08b44edde0435f2115dc66e25f2100f3ab/protobuf-7.34.0.tar.gz"
    sha256 "3871a3df67c710aaf7bb8d214cc997342e63ceebd940c8c7fc65c9b3d697591a"
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

    system Formula["protobuf"].bin/"protoc", "--nanopb_out=.", "test.proto"
    assert_match "Test", (testpath/"test.pb.c").read
    assert_match "Test", (testpath/"test.pb.h").read
  end
end
