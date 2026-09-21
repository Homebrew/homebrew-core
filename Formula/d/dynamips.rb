class Dynamips < Formula
  desc "Cisco 7200/3600/3725/3745/2600/1700 Router Emulator"
  homepage "https://github.com/GNS3/dynamips"
  url "https://github.com/GNS3/dynamips/archive/refs/tags/v0.2.25.tar.gz"
  sha256 "af8e5c24906382b041e0f86f8e4290cff78e8ab4f3aa6097f9f7d666d53368bf"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cc06802900d1ad0a059249764ca05d5031e76379007d64b5a62cd30bf1a927ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "162d5d7fd38e318d1298a6a5f19bd246aeef23c9107a8b6211a45285a8481c8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0c8519babac9fbc49fc9b55242c1943c89adc2d380b32dd46f655292f132b50e"
    sha256 cellar: :any,                 arm64_linux:       "9133fad684a0052da2b89a87c12ac0148cd16d8c7a8a505c01bdbddaf3e9f832"
    sha256 cellar: :any,                 x86_64_linux:      "2ac58a80ac5965ab0cc7b89beac0ab825c7453994428147a65c4a5f2dd0859c0"
  end

  depends_on "cmake" => :build

  uses_from_macos "libpcap"

  on_macos do
    # https://github.com/GNS3/dynamips/issues/142
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
  end

  def install
    cmake_args = ["-DANY_COMPILER=1"]
    cmake_args << if OS.mac?
      "-DLIBELF_INCLUDE_DIRS=#{formula_opt_include("libelf")}/libelf"
    else
      "-DLIBELF_INCLUDE_DIRS=#{formula_opt_include("elfutils")}"
    end

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dynamips", "-e"
  end
end
