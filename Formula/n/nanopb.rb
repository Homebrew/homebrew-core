class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.2.tar.gz"
  sha256 "98b8cadce538f37230ca0d5d8796894e3067d58dd2fb2618e6712c7362bdd8bb"
  license "Zlib"
  revision 1
  head "https://github.com/nanopb/nanopb.git", branch: "master"

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "12ba90acfc82663b0dc130cb72e75de6ea002030276549103d6aff8f5dce3f92"
    sha256 cellar: :any, arm64_tahoe:       "a563fb6d87fd8787d7500cac76ccd5b7d99a3bb518ba16ecb714d16846af518a"
    sha256 cellar: :any, arm64_sequoia:     "2c9c2322a8dcf784b2e5b33ddd7f2cb6af7b88d44165f6b4bf20970ef5fb600f"
    sha256 cellar: :any, arm64_linux:       "97e1716d790bb2150317200a0c4ce82975363ff25cdf4d901e32faf938255bca"
    sha256 cellar: :any, x86_64_linux:      "d76a02d2497565d76b57d61407430dce2e976919ef830a4e997d59543c599e9a"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :no_linkage
  depends_on "python@3.14"

  # Restore `package_name: "nanopb"` when 0.4.9.2 is on PyPI
  pypi_packages package_name: "", extra_packages: "protobuf"

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
