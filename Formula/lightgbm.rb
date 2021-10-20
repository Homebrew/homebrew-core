class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v3.3.0",
      revision: "fa4ecf4c4da57b1889e39c872eb5449080f1e02e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "86543de1c28323e721e8e26bd6ec083c52ce56a8e45d5dbc86defcfe0718e7a1"
    sha256 cellar: :any,                 big_sur:       "137ff9e308c60618213afde25c067f20fd89a368beb2cfc458d4d6aa99818af1"
    sha256 cellar: :any,                 catalina:      "c53b3335405f3790c2ffe78fcd79aa566c6059f62116c9bee8052424c3cac413"
    sha256 cellar: :any,                 mojave:        "5466963bd6aaaf8b053ea1f16290b8cfbf286f5d84dadd0ede511a58d3888486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afca9535a1de1d1a99f42adc7ae5b120ce89de2b8b5de38e176e8a7cb3a82ff8"
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
