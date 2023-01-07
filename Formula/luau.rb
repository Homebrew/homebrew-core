class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.558.tar.gz"
  sha256 "3484adddb18872700e033f5917af44d90c266f9e0fff2fac21aec1061f472a06"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bb03b1c67fbb5b369a494a207599f642b0a67953bf37dad89226b2a85ce3c91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "002effcc02934a3b0c943944c1f5d7aaa7dd173eb0c770ff32a4d30d4689d263"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adaf5412eb46a3dd4a388268e0e481064423d437634192e720efb432e62a544d"
    sha256 cellar: :any_skip_relocation, ventura:        "0f3f8d8d9336111e8b48d25f5ccff2e83c0f6d14eddbc88a132f72a51d7ee12d"
    sha256 cellar: :any_skip_relocation, monterey:       "a405b1486fa072a3ad3392f6deb402aa17c29feab2b6698d65b117763f6a958c"
    sha256 cellar: :any_skip_relocation, big_sur:        "18b890b2ccec95b675e38324ebb06eb7def2e2ce8fe2f058c7ea4144a5f16970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eca9bfbd5df132dc6e09746a05ee0aa9163d3d306b0d7de77fa74f6b1b9650c8"
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
