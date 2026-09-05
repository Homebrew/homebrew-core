class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.2.tar.gz"
  sha256 "98b8cadce538f37230ca0d5d8796894e3067d58dd2fb2618e6712c7362bdd8bb"
  license "Zlib"
  head "https://github.com/nanopb/nanopb.git", branch: "master"

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "545c00b1ff8f69f6104f8a3973c98fc07a3055632e7338dd2a1bc9c3cf17d2af"
    sha256 cellar: :any, arm64_sequoia: "c645ddff14a09b5922b976a6638317af9928504a87a8a1432d2038e11d4b590b"
    sha256 cellar: :any, arm64_sonoma:  "13a2f8f770dfbe5e432b02851b7eba08e49b6e29f37bc8a8e311766cf51115cf"
    sha256 cellar: :any, arm64_linux:   "c1058306daf087765fd541a3e241331962364f13becb0909807e41be46f8a0f1"
    sha256 cellar: :any, x86_64_linux:  "42999f9161873535877861e40049b26bde44d665131a5d32311c53a67447b036"
  end

  depends_on "cmake" => :build
  depends_on "protobuf" => :no_linkage
  depends_on "python@3.14"

  # Restore `package_name: "nanopb"` when 0.4.9.2 is on PyPI
  pypi_packages package_name: "", extra_packages: "protobuf"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/86/73/f66c748df06e7fe24e658eddd600d19c4b40bad836c97ce2d0ad9851fb6b/protobuf-7.36.1.tar.gz"
    sha256 "d0f6470f0ce2b84e3feaea2d4b816378b37ba4d4aa08a274305373de93e2d524"
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

    system Formula["protobuf"].bin/"protoc", "--nanopb_out=.", "test.proto"
    assert_match "Test", (testpath/"test.pb.c").read
    assert_match "Test", (testpath/"test.pb.h").read
  end
end
