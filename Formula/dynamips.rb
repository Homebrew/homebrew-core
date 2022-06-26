class Dynamips < Formula
  desc "Cisco 7200/3600/3725/3745/2600/1700 Router Emulator"
  homepage "https://github.com/GNS3/dynamips"
  url "https://github.com/GNS3/dynamips/archive/v0.2.22.tar.gz"
  sha256 "5b3142eb4d2780683ea8781d5f4da6fc39c514d36546392508c74da8ba98240b"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c22fc3fa8a288516a6b07e6f2d9e00a318fe8ea13841e57a46fa6cc3a30f2b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "028ac7c712f19f93d0265585c4b32c2be4a347ddc12e99110a232fc309c2fe61"
    sha256 cellar: :any_skip_relocation, monterey:       "5385bc27852708af49d6b8d307de69b39c9c10f7ad3e45ef77dd13b68588319a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4d95a8dac4e17b3189f215c2e2c7401a065391b6335fddd86b30c05389c11ae"
    sha256 cellar: :any_skip_relocation, catalina:       "5b38c4fe753e0372420a0f020b6bae01d208663c6f9ed878c1b8b81fcca39cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab60c90c43a95d54763147dc90134412b795fbb6f5cadf2841d7333adc5ea523"
  end

  depends_on "cmake" => :build

  uses_from_macos "libpcap"

  on_macos do
    depends_on "libelf" => :build
  end

  on_linux do
    depends_on "elfutils"
  end

  def install
    cmake_args = std_cmake_args + ["-DANY_COMPILER=1"]
    cmake_args << if OS.mac?
      "-DLIBELF_INCLUDE_DIRS=#{Formula["libelf"].opt_include}/libelf"
    else
      "-DLIBELF_INCLUDE_DIRS=#{Formula["elfutils"].opt_include}"
    end

    ENV.deparallelize
    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/dynamips", "-e"
  end
end
