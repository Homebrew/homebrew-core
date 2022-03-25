class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.520.tar.gz"
  sha256 "da749bbdd639fedcd3d352b3b684113354312bf7c2b8019e51891739134bb526"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e864aa3fa057bbd6ef5b0c850931ef94d01c96e144e8daa0a4c6b3a2e987b55d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "546940bfc3927a2f82c1ceb0a20cd91c607c19ceb9c47b820310406d35cb12fb"
    sha256 cellar: :any_skip_relocation, monterey:       "232114a241a514636898188f242ee2cbe46e13dc9e405fd988b441ff42482ab8"
    sha256 cellar: :any_skip_relocation, big_sur:        "847157e7d65f9e10f60cd1ce4d4d63b68019e6c38bc2af660c24034f0e2fdfdd"
    sha256 cellar: :any_skip_relocation, catalina:       "729da4f5c2349c288512c0c94ad2f4d22dcd7dd7939a3e27395b740e0b04c722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a7c2ca59656381aa88dcda8c4e2f6766c3f4630c70e27495e335c066d4a2025"
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
