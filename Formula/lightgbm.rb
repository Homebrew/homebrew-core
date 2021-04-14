class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v3.2.1",
      revision: "b8e38ec1eb8020052d5b39e31e9f2cb6366fb873"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "52ffad72f363d9b12114efa361c2705637da9864c27c9fc8a6050f70c813905b"
    sha256 cellar: :any, big_sur:       "33608cf6e0f7e9c7600eea808116994a05764b88a3f6fc82a576e59d5d34692c"
    sha256 cellar: :any, catalina:      "522fd1f29a2bf3090f7dbe00034a9f8b6580255e0aeddb9bfd99de9bdc89cc1b"
    sha256 cellar: :any, mojave:        "a4eb51106a037389383eb4e32f26e894ab68dab901bcc0305e2270c9f8c51ff5"
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
