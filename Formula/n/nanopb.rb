class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.9.1.tar.gz"
  sha256 "882cd8473ad932b24787e676a808e4fb29c12e086d20bcbfbacc66c183094b5c"
  license "Zlib"
  revision 1

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2752728b93432f3038baf1265309816fa727ca0047be7e4741a5b2b66dcb2db4"
    sha256 cellar: :any,                 arm64_sonoma:  "6a8a0983e5cef877a39983eee07a476e9ce6872ac35e8d20612ccc34c32ea87e"
    sha256 cellar: :any,                 arm64_ventura: "a7acbc645e97667aa9924d1fb85a579cd6c4f628e79deabb467033a027db4de4"
    sha256 cellar: :any,                 sonoma:        "d60addc61d0a2454f9118b4b8c727c59ba271b4aa04c758d2b242dbb5514dff5"
    sha256 cellar: :any,                 ventura:       "39d4114c8a87b5bffac3e7dd7c230fb774ecd1c3c3b09d91e5bb9d631f43b5c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ad24fb383ea51833f9d0f785b5f5ad96694e167becdfd8fe209e1b6815a31fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efeceec89652aa4621f289e3b1918c83fb768f958792cf85cee62f3dd38b4471"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.13"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/55/de/8216061897a67b2ffe302fd51aaa76bbf613001f01cd96e2416a4955dd2b/protobuf-6.30.1.tar.gz"
    sha256 "535fb4e44d0236893d5cf1263a0f706f1160b689a7ab962e9da8a9ce4050b780"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/81/ed/7101d53811fd359333583330ff976e5177c5e871ca8b909d1d6c30553aa3/setuptools-77.0.3.tar.gz"
    sha256 "583b361c8da8de57403743e756609670de6fb2345920e36dc5c2d914c319c945"
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
