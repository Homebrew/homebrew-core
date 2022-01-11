class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.509.tar.gz"
  sha256 "838463904d3564b756b167b1d2959664f2ff1e07224acf3ed69753724fab0754"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e13fecc73ef9a945820ca7243219103b1b3eae84cd3967b3e87358c96bbf910b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e66e39a031bb9ddb782f8e16f49a4daba9f0a7cd5afe29eded7200f93af554dd"
    sha256 cellar: :any_skip_relocation, monterey:       "169e4d7b6c88bd535e8669a24d1d0a4a76b6c743d16c5b59fab4f10dff6b22e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9d0a77f5ed06574438d80c33de7455c6f181010222ce5d1261d26e8c624034b"
    sha256 cellar: :any_skip_relocation, catalina:       "80ea3db94176b6740252cfe845d365e8059180c157e835ae62c1e9ebd1296b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acdd2f1fca2cfd57319029e6c846528ce3716a3168c74bc963303ff61abf2cb1"
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
