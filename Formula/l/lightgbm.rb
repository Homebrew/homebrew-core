class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v4.6.0",
      revision: "d02a01ac6f51d36c9e62388243bcb75c3b1b1774"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc3255c6fffd11ce1676c2597de6557aa0b554c9fe11d1ad8b2759fe2cd7ecd0"
    sha256 cellar: :any,                 arm64_sequoia: "af06af6e8c5957e2e0285816921478539a819d1a48f7ef9336812afaf1129bcd"
    sha256 cellar: :any,                 arm64_sonoma:  "924638eeabc00965e741df6e5444b0139dea77fee9316ea4b13aee12e43baeda"
    sha256 cellar: :any,                 arm64_ventura: "b34c5223a88dbc4875008eb7a1f3015df5481f68a3d79b10ab7a1f6e8d74a792"
    sha256 cellar: :any,                 sonoma:        "f385bfe479b4c3c5bbe7547807124b2d9ca3b4d3866105e96f9bcaee8c199494"
    sha256 cellar: :any,                 ventura:       "80b5259b0063771afbd9d458c6fb1a4d0c8ca3e731d73eaf6386b726a331c001"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68e47a0dca38a807ab030626f65d442a6f89852040d6292cc8e53b181c490664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1915c11735c5ebf8f666c1895c6f7d5430777352c10ed5eb96f7692ba18bc130"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples/regression"), testpath
    cd "regression" do
      system bin/"lightgbm", "config=train.conf"
    end
  end
end
