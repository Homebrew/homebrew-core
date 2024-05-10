class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.625.tar.gz"
  sha256 "4dd9295a67c2de6536b6e1208ea81cebfc5caefadcdacd7e09341c7a1dbbb9e2"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7e2259260865337b231d69fd0a528fe5d294542460125cda4749140fc90029cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc161f17ac4ba18540f0ac7c2d456442a6a15eb3e917f477bc58a0219f21de9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "123e4aaa81b8da57f08562937dd335ee2755724e00ba9a019377938f52f655bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb84844e5dde06bb74a9082afe34006fd74cebd120a48ec2b29c414ffff13da1"
    sha256 cellar: :any_skip_relocation, ventura:        "952e65d4b48ca4d9c0ea33727f295ceb94b4870654c254330960bd551120faeb"
    sha256 cellar: :any_skip_relocation, monterey:       "e420afeeb6ef97ab0b24295f28a8469164644f858f48bbc8649177586825f587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd86f1b223e2586d9ea38e8f41c609a32aa1590c2064fa58c6fa2124f7cb3e5c"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install %w[
      build/luau
      build/luau-analyze
      build/luau-ast
      build/luau-compile
      build/luau-reduce
    ]
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
