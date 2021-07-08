class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.8.0.tar.gz"
  sha256 "f7d9223e784607f78673f858deab2e3cfed95a4af39fa63366af83a4987e9aaa"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4c6731bc92a8e6fc7b50763fc19428d9a04b3f92e4dc1d7ce6cf5a394b331eb0"
    sha256 cellar: :any, big_sur:       "50671feeaae23a717b962663c1c42cd7a4efe9b0f5ce2b4c6e9442423606de8f"
    sha256 cellar: :any, catalina:      "c583a91963b78fe48e2b64aa43094e7a16e49437b09de197697ca964f569f61f"
    sha256 cellar: :any, mojave:        "7766c659470a00bef9844f3d3518af9bbad8f916be503ccf59ad201624aa9a09"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  # Apply https://github.com/fluent/fluent-bit/pull/3564 to build on M1
  patch do
    url "https://github.com/fluent/fluent-bit/commit/fcdf304e5abc3e3b66b1acac76dbaf23b2d22579.patch?full_index=1"
    sha256 "80d1b0b6916ff1e0c157e6824afa769f08e28e764f65bfd28df0900d6f9bda1e"
  end

  def install
    chdir "build" do
      # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
      # is not set then it's forced to 10.4, which breaks compile on Mojave.
      # fluent-bit builds against a vendored Luajit.
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      system "cmake", "..", "-DWITH_IN_MEM=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
