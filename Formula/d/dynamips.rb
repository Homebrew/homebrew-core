class Dynamips < Formula
  desc "Cisco 7200/3600/3725/3745/2600/1700 Router Emulator"
  homepage "https://github.com/GNS3/dynamips"
  url "https://github.com/GNS3/dynamips/archive/refs/tags/v0.2.24.tar.gz"
  sha256 "3956501eb49cb45770226a9a1de3a2f922eec5f47cc1b5fb83097f073456e4a8"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f975f78a853c091e7a5240a0a3af2bffcb10f6da5d846d65ef6e3e20c2095641"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46e1e7197e057e23b506ba0c2af895a59cf85a4c80d597e2921be2d186cdbde2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75a7b329b142c4301ab39598cba086eeb4eca70e0a0b2ad59f070ac666982098"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fb56ae3f88704519bf9763700ba331b4c02a28dc83a8dae3ccf5188c2079624"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b747fd92dad493dbd8eb7d63781845ba7e3583479616ef6d67bc7c927bc4f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7a29bef644cc5a300e9c577145504166815f21ff8d585f8ba99101c277ded8c"
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
      "-DLIBELF_INCLUDE_DIRS=#{Formula["libelf"].opt_include}/libelf"
    else
      "-DLIBELF_INCLUDE_DIRS=#{Formula["elfutils"].opt_include}"
    end

    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dynamips", "-e"
  end
end
