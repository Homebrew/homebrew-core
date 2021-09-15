class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v3.2.1",
      revision: "b8e38ec1eb8020052d5b39e31e9f2cb6366fb873"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ae442333df20db31769e25fedd3b32a4238eaa2a94f178c237fc567373f2a245"
    sha256 cellar: :any,                 big_sur:       "84e713ec15bd966c737fc70b5650a725a21f3551df897a6160b2f27d8561d3a1"
    sha256 cellar: :any,                 catalina:      "1c9178a701a721781329f0c4dc45bc955f84a5ee93f6f68fe817ae33168adcab"
    sha256 cellar: :any,                 mojave:        "f714a735772ed4246dbf5bfff4c6c1f1b4d1cf36680488b16e80c19a1e3d3334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bbae9728fa5306d0f12cdabf901c5b64df6a6a73ec9d0547e5c1290a751241a"
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, "-DAPPLE_OUTPUT_DYLIB=ON", ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples/regression"), testpath
    cd "regression" do
      system "#{bin}/lightgbm", "config=train.conf"
    end
  end
end
