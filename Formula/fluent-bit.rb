class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.7.8.tar.gz"
  sha256 "e31541570757d70510194ea2cbe6a34bdea88791fd93f04c9800b9bf8188eaf4"
  license "Apache-2.0"
  head "https://github.com/fluent/fluent-bit.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4ee1823841ea4039f3850502c17b2b1cc0f1aa8ee7e49b0ec81250985dd1664b"
    sha256 cellar: :any, big_sur:       "c9fa51a3d352cfac250c8deefbd0917ac7d4f295a0490d86759e4138a85a5a40"
    sha256 cellar: :any, catalina:      "924f6a517016a879fdd4ce77d9ac80fea0d3a0589f1e9f39e2aeb6b68ad22a57"
    sha256 cellar: :any, mojave:        "3a13904044dd24b0fb49fd834597d88ff250ce795be7c337495d2c791271064a"
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
