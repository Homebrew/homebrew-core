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
    sha256 cellar: :any,                 arm64_tahoe:   "2aab322dc0a511e3591fcefdddd67c08ecccdec80d00051520467271e3e1bc4c"
    sha256 cellar: :any,                 arm64_sequoia: "4db08dc9cbe4a3f64adc3151ea998862c0ba6b0ecc4696dd2942a337f8f446e3"
    sha256 cellar: :any,                 arm64_sonoma:  "d3390dd28c9eac2e341790e1d5272dafd4ddcb3c7e3197bf2ff586b4043a68e3"
    sha256 cellar: :any,                 sonoma:        "4d33f2d6478c0cbaf44224d1b5b2347ff02ea2ab917edeada6ef59df8d500da3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51afe17f1b7f66194cdf6f6beb82e70b3dd1aac928668730cfb184e55caf97c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a65e4addac362ebbe74acd648c7df851202404e058382d4a85a584b669235e99"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.14"

  pypi_packages package_name:   "nanopb",
                extra_packages: "setuptools"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/53/b8/cda15d9d46d03d4aa3a67cb6bffe05173440ccf86a9541afaf7ac59a1b6b/protobuf-6.33.4.tar.gz"
    sha256 "dc2e61bca3b10470c1912d166fe0af67bfc20eb55971dcef8dfa48ce14f0ed91"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/86/ff/f75651350db3cf2ef767371307eb163f3cc1ac03e16fdf3ac347607f7edb/setuptools-80.10.1.tar.gz"
    sha256 "bf2e513eb8144c3298a3bd28ab1a5edb739131ec5c22e045ff93cd7f5319703a"
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
