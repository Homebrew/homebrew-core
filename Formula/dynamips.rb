class Dynamips < Formula
  desc "Cisco 7200/3600/3725/3745/2600/1700 Router Emulator"
  homepage "https://github.com/GNS3/dynamips"
  url "https://github.com/GNS3/dynamips/archive/v0.2.16.tar.gz"
  sha256 "0fcf18d701898a77cb589bd9bad16dde436ac1ccb87516fefe07d09de1a196c0"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0dff444d30aee825fb6324fb32b78514cf6dcd4c7bdfcaf6e92d3845338faf8" => :sierra
    sha256 "4e81ee17602f6ef530e3e8e36d0f71b453ed7d790cc17a336b6f22143f7eb6a5" => :el_capitan
    sha256 "6b5cee3e5085ace5329386b70e72a357e3d3a2f980de60eaa4104a2db4e8620d" => :yosemite
    sha256 "c29879e87cb14a0ba3f6c031fa52a3864566e84930593125ec47f6a7ca02cd96" => :mavericks
  end

  depends_on "libelf"
  depends_on "cmake" => :build

  def install
    ENV.append "CFLAGS", "-I#{Formula["libelf"].include}/libelf"

    arch = Hardware.is_64_bit? ? "amd64" : "x86"

    ENV.j1
    system "cmake", ".", "-DANY_COMPILER=1", *std_cmake_args
    system "make", "DYNAMIPS_CODE=stable",
                   "DYNAMIPS_ARCH=#{arch}",
                   "install"
  end

  test do
    system "#{bin}/dynamips", "-e"
  end
end
