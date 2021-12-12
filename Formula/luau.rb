class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.507.tar.gz"
  sha256 "cd9220246f2d5512d80e17f9899b6a890d239f21c863885bac673d615e63f85f"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "849be2ebf882eff02ef560159838417458b0470a48ebc0e5ca5c529728b81687"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc950cd53f30705fdee60e95eb322207effa41d7256551365aa93d19a2f93b51"
    sha256 cellar: :any_skip_relocation, monterey:       "1f15eebbb729a88408b21fec92f4bd6fc25ebe6bc4bacf1459727e94d24ef166"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e09fd4cc856b0022e6cd05c56b06b77a64bfe4b5bad042757a020ab69447156"
    sha256 cellar: :any_skip_relocation, catalina:       "83fe0d98b947304153231ff7dc0b6e14b7e7a73eca72e26d1275ad594310b556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57f2a47a5416087ea65f6b26629d3fa22ce12cc1afb035ad387e80685350bb6f"
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
