class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.554.tar.gz"
  sha256 "46c2cdf633e21f879f7e8b7b72f84d190170c6e697e3a64cee12e9e9ef3376df"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1127a481258b2b242ae4a5787cc50a632e7c085c605979a60e5ec15972ef80e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18f332db9e7b8bd4d87b4b25a1b4107f66365cdd5a24e86625614cf1fab1c813"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f77b1c8f4e835b527cd562ff88b63e992a2dde37c7b5c78ee0c2e9b27d0a282"
    sha256 cellar: :any_skip_relocation, monterey:       "ae478472adafa43ed348ac6505ba250afe07592dcb9999bb47f0efc065b1fca7"
    sha256 cellar: :any_skip_relocation, big_sur:        "17e410450a603eba42c1e10fb4acb2cfa9373ceaf068ca854347082d813eec84"
    sha256 cellar: :any_skip_relocation, catalina:       "b5419de39ec2378d8c74354485e65a05113d43eff131e67ac440fd631cb6b854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6871a01c921dbc7a3f431a059b15a07951c12112959983f3f4281e587065aacb"
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
