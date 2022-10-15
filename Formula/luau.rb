class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.549.tar.gz"
  sha256 "786581ebe7cbbcb37cb4ed9c8817d6689cd82e910b945f2ce17fe6df2888e2d4"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d5e4effc7bbdc9c221285668d06ad2cbf589787f99e9c9edaf52542ea849c9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbea42dd415651406c75e9ebcd9833dda8ee402c7fed3e8d99691c1463899add"
    sha256 cellar: :any_skip_relocation, monterey:       "85f2fec94bd82ef58cb5dbcc172420311a634e41d5613b81ae7dd6f8b1f08fb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "31f91d603c40924e58bfa0f60f24f4e5c967d0de16f54f5a802d75f7e370eab4"
    sha256 cellar: :any_skip_relocation, catalina:       "7a80a77687955f6678158ee54829ef915f35a4335abd6a44534b8701917a1312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f042753bedf614a04746664b32856043db7656aafb4b60c38c59bc639a4c642"
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
