class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.523.tar.gz"
  sha256 "1caa530ad87989c5c954c9864658702247f90b2e7c19417ce015a0572ec24e95"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91ba65e457ef0bafd298a62ea365c0ca07cc2197e4ff2bb8aa87df6de3cf43bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9f5bc5727244a1189cb0d38040f6d47d58eb76e5ced698fe81f3e8046a8cc14"
    sha256 cellar: :any_skip_relocation, monterey:       "07ec414d2c5d9e30a83bd0311ab4ac892d4587f20bc3f6ac9f0e355108f6d5f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea84e388116051fd87d6bf79d86cf7ba4eb31a26348307327f066442ef402845"
    sha256 cellar: :any_skip_relocation, catalina:       "f9c164463eb4f666071ae58eee2b75f9f9b14e1b4ce2c82f1fe98d8e39c228a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79de6085d77d39e3fe5cf2683c9438b989ede2c63ce86e2d5735a7fdbc42cf45"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DLUAU_BUILD_TESTS=OFF"
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
