class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.1.tar.gz"
  sha256 "882cd8473ad932b24787e676a808e4fb29c12e086d20bcbfbacc66c183094b5c"
  license "Zlib"
  revision 2

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7d76fc86d847a068c45c8a5ba8a0b3b11b8de23f227d093cdb285e15cd982e8a"
    sha256 cellar: :any,                 arm64_sonoma:  "f9d5864283a0d79f5aaeffac33c215d12d244e821e5f9955dcb4e20fb7d6e92e"
    sha256 cellar: :any,                 arm64_ventura: "7e75a8d1f9e8f2f2c9d497b4fe414bf5f88421d5c35abd960893fb89b081f716"
    sha256 cellar: :any,                 sonoma:        "88dd38904d068f44085a8f267038c76957c9f8c6ae37981bf20ddc0db6c37262"
    sha256 cellar: :any,                 ventura:       "ee8ee09d5e0e937e5bebc576cb5ba7db3833ae7ac0367a43a0326d83900ed669"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0892cc465d41cb9eeca87e20de7758d1dedb166471b79ed3d48a1b2746f3e9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "794045035602e33641f7e4b9fcf1e2d1ec010d5ccfcb5645c2fc25e1ac544309"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.13"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/13/48/718c1e104a2e89970a8ff3b06d87e152834b576c570a6908f8c17ba88d65/protobuf-6.31.0.tar.gz"
    sha256 "314fab1a6a316469dc2dd46f993cbbe95c861ea6807da910becfe7475bc26ffe"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9e/8b/dc1773e8e5d07fd27c1632c45c1de856ac3dbf09c0147f782ca6d990cf15/setuptools-80.7.1.tar.gz"
    sha256 "f6ffc5f0142b1bd8d0ca94ee91b30c0ca862ffd50826da1ea85258a06fd94552"
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
