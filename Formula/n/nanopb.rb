class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.3.tar.gz"
  sha256 "3dcfe9e47b7ae5f5e567ca8df7a5d1c8e43996898ad20c7ef9f61c4054b2d250"
  license "Zlib"
  compatibility_version 1
  head "https://github.com/nanopb/nanopb.git", branch: "master"

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a69403355f3e481abc46c743b42de8629ecb2e76b505888219014413a9b5c14e"
    sha256 cellar: :any, arm64_tahoe:       "d1361fdc4268124a730fffe8917a6df92c569b9f03a0a54db6b10f91a926abfb"
    sha256 cellar: :any, arm64_sequoia:     "f2bac7c12022a82ffa21a401064e10c052df7218f0d50ea0d0baabda6ba5eb0e"
    sha256 cellar: :any, arm64_linux:       "225aa2b92fec562563b2e5a861e422e1ea8d163773cbdb5d07ab7d6d4886a528"
    sha256 cellar: :any, x86_64_linux:      "34d3ff5365eb36e996eff927930ae3e6f8a8dbb5888329cc22619b59c8e48974"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :no_linkage
  depends_on "python@3.15"

  pypi_packages package_name: "nanopb", extra_packages: "protobuf"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  def install
    ENV.append_to_cflags "-DPB_ENABLE_MALLOC=1"
    venv = virtualenv_create(libexec, python3)
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

    system formula_opt_bin("protobuf")/"protoc", "--nanopb_out=.", "test.proto"
    assert_match "Test", (testpath/"test.pb.c").read
    assert_match "Test", (testpath/"test.pb.h").read
  end
end
