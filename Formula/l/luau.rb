class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/refs/tags/0.593.tar.gz"
  sha256 "1cbe4390ef71bb0f2210853978c900974aa02fab73de92b6e18e7bb10dd0e3c1"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ae47d1b709928b6a04189a3840f6aeb1060300223da117c641f11e03f280daa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c61d85188da00dd84f310f44ca373d1599e27fad0cefd86001bea89c98ac283b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "150c86920b4fefa2251027fc5544c866dd11090d7be6df6fe5e3915822bd0ea4"
    sha256 cellar: :any_skip_relocation, ventura:        "cf3d482256fe5329789f746327657708f6bb2ea23d810df623a66fe69efcf027"
    sha256 cellar: :any_skip_relocation, monterey:       "f687445a9727377d913db1635f18f40650b8c0ffbf26472fca4fc4b4471f6490"
    sha256 cellar: :any_skip_relocation, big_sur:        "d68cddceb7a5a5a8cd1fda3daa89c22343a92bde0591696576b3faf1ba8c18b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8277aa1507dc7879d450bb94e3beb8186cac29bd962473218dd4005fe61c033"
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
