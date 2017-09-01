class Dynamips < Formula
  desc "Cisco 7200/3600/3725/3745/2600/1700 Router Emulator"
  homepage "https://github.com/GNS3/dynamips"
  url "https://github.com/GNS3/dynamips/archive/v0.2.17.tar.gz"
  sha256 "d524ef32b78dd7384775920604912d3b4b212ded338cc4df930b0086df1e81ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "c94a3d1c7456287ad68113af62df3590674e4a41ab9f5ab383b9291af8d919ea" => :sierra
    sha256 "3c2427ca53100fa0e44131d7ac4a33ec6a90a6bee45411c01de7258b4fd00836" => :el_capitan
    sha256 "2fefd603afce1231c35103db5af5b64594cc17411238d5f783f31dfd99d513b2" => :yosemite
  end

  depends_on "libelf"
  depends_on "cmake" => :build

  def install
    ENV.append "CFLAGS", "-I#{Formula["libelf"].include}/libelf"

    arch = Hardware::CPU.is_64_bit? ? "amd64" : "x86"

    ENV.deparallelize
    system "cmake", ".", "-DANY_COMPILER=1", *std_cmake_args
    system "make", "DYNAMIPS_CODE=stable",
                   "DYNAMIPS_ARCH=#{arch}",
                   "install"
  end

  test do
    system "#{bin}/dynamips", "-e"
  end
end
