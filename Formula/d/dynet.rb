class Dynet < Formula
  desc "Dynamic Neural Network Toolkit"
  homepage "https://github.com/clab/dynet"
  url "https://github.com/clab/dynet/archive/refs/tags/2.1.2.tar.gz"
  sha256 "014505dc3da2001db54f4b8f3a7a6e7a1bb9f33a18b6081b2a4044e082dab9c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "13425cf394c191250670db43c3090541143f76d156e06a11f2cba7294333926e"
    sha256 cellar: :any,                 arm64_sonoma:   "f64ed80ea96d473dd96800bdd9928eaa1b4fbe56cef809daf8d5241d3fb936e7"
    sha256 cellar: :any,                 arm64_ventura:  "326d11401b0db3d2294c46c7f3835cf497954f61fd14f8b6508461ef7ec6d8cf"
    sha256 cellar: :any,                 arm64_monterey: "5344a9cc883ddbea6def01dc950bed7aca9fe06ba67d52d10349ef46af17879b"
    sha256 cellar: :any,                 arm64_big_sur:  "812e42a82c70b8c049582c897d8d6d645c7892cb29fe742bc4c857f6d915cb44"
    sha256 cellar: :any,                 sonoma:         "98c5c6da074e6b0e7eed5c60d8365945bb78b5e752e13f13ac345c08d2cb3acc"
    sha256 cellar: :any,                 ventura:        "88af1a5787e4b2d6919b16a94c72041009f72f2e0c58b03e11410206aa7b3eab"
    sha256 cellar: :any,                 monterey:       "ad0cf700f000d6b03ad08ec1074508eb01f442019f6e1c59fe7a83325bb84add"
    sha256 cellar: :any,                 big_sur:        "8bd7104e80fd7166539f40cf30f4c67ac643f096920582ec6702f81b06ff6910"
    sha256 cellar: :any,                 catalina:       "d699aaf34e601dca84a10d735a822954de02b2139757699da77df2632d9ae95c"
    sha256 cellar: :any,                 mojave:         "edc5ba7539f3c224b091ae08b2f23ae667f6851ebbc10515e410fbe2efb2aec4"
    sha256 cellar: :any,                 high_sierra:    "a8b5c58b84c07911937f5b2c633e38e884f860ac97fc45881bfa817f6045c467"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b34f9dd2d85fa95eb0d7894a2c3e8ae7758c8c2e0caeb10e69fef515d6249398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6b8b9842ad483b362f47b1a5562e4cf839c26be13dd4fc525ed456f1dae230c"
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  on_linux do
    on_arm do
      depends_on "llvm" => :build

      fails_with :gcc do
        cause "https://github.com/clab/dynet/issues/266"
      end
    end
  end

  def install
    args = %W[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/xor/train_xor.cc", testpath

    system ENV.cxx, "-std=c++11", "train_xor.cc", "-I#{include}",
                    "-L#{lib}", "-ldynet", "-o", "train_xor"
    assert_match "memory allocation done", shell_output("./train_xor 2>&1")
  end
end
