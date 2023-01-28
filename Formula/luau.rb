class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.561.tar.gz"
  sha256 "1365863fe08e8dbb21551a507d4a12c2b013ff33dd18f3975681da756ccc5d2a"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b3cc5546b509a2d44bb1866ebf2e47eefd6bb7bc72f11f782e5e77ec77e9d2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2882d2b94d0d03539e6df07161fa2b95c8e69ac84290bcf80836ddf3a0e7b3a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89a834feedc204ef9c7de597d424b97728d72d363a33cab91c4f688c5e592fb5"
    sha256 cellar: :any_skip_relocation, ventura:        "2435293ecf9144bf2d17477482c933955d5e189d3a69e4df8d39d02e86be656c"
    sha256 cellar: :any_skip_relocation, monterey:       "ed8c5f21437ec4e36970804ec81aab7df63263225b760758b8c436013508bde0"
    sha256 cellar: :any_skip_relocation, big_sur:        "201fb6c0b5d7d23714d4f853cff87cb3e8d0b06c88120289a665f53a5e1e3032"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "820b993a51e9555ba755401409b8d47567045452452340271cdea48a9bf35415"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
