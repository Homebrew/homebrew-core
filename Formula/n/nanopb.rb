class Nanopb < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "C library for encoding and decoding Protocol Buffer messages"
  homepage "https://jpa.kapsi.fi/nanopb/docs/index.html"
  url "https://jpa.kapsi.fi/nanopb/download/nanopb-0.4.8.tar.gz"
  sha256 "d685e05fc6e56fd7e4e3cacc71f45bd91d90c0455257603ed98a39d2b0f1dd4b"
  license "Zlib"
  revision 2

  livecheck do
    url "https://jpa.kapsi.fi/nanopb/download/"
    regex(/href=.*?nanopb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1f15525c49e93031d767a77fe33cf6d63e7331341a337bac07127fc52e5b231b"
    sha256 cellar: :any,                 arm64_ventura:  "6919bef03e1f792e010579d18b2a45f83a258d76d9dfd273ad94dee35b31e576"
    sha256 cellar: :any,                 arm64_monterey: "260303ae3cff7074cb22c1bed0e21ebe2e2b584007ca1cca0144de576ac24861"
    sha256 cellar: :any,                 sonoma:         "e668b434826985bb97dea2f351fd2eea1bc563c69f4ca3eb2bc5cc197e1c0015"
    sha256 cellar: :any,                 ventura:        "be8bfe95b11aeb6c73a8298e2467104a3f5ed38d4c04be0ed182ad3094aa3a46"
    sha256 cellar: :any,                 monterey:       "b943a65449f1614bc4c7b608adac7a8f87e62dd89c7b5e358aafb12b0ca62869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edef625d5954c642121ad269d1e3978cec2f653d1bdd9868086e46a0b289438c"
  end

  depends_on "cmake" => :build
  depends_on "protobuf"
  depends_on "python@3.12"

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/71/a5/d61e4263e62e6db1990c120d682870e5c50a30fb6b26119a214c7a014847/protobuf-5.27.2.tar.gz"
    sha256 "f3ecdef226b9af856075f28227ff2c90ce3a594d092c39bee5513573f25e2714"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/65/d8/10a70e86f6c28ae59f101a9de6d77bf70f147180fbf40c3af0f64080adc3/setuptools-70.3.0.tar.gz"
    sha256 "f171bab1dfbc86b132997f26a119f6056a57950d058587841a0082e8830f9dc5"
  end

  def install
    ENV.append_to_cflags "-DPB_ENABLE_MALLOC=1"
    venv = virtualenv_create(libexec, "python3.12")
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
    (testpath/"test.proto").write <<~EOS
      syntax = "proto2";

      message Test {
        required string test_field = 1;
      }
    EOS

    system Formula["protobuf"].bin/"protoc",
      "--proto_path=#{testpath}", "--plugin=#{bin}/protoc-gen-nanopb",
      "--nanopb_out=#{testpath}", testpath/"test.proto"
    system "grep", "Test", testpath/"test.pb.c"
    system "grep", "Test", testpath/"test.pb.h"
  end
end
