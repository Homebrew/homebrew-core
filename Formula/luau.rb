class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.537.tar.gz"
  sha256 "24122d3192083b2133de47d8039fb744b8007c6667fc1b6f254a2a8d72e15d53"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "224db1475a1a328c97704231ed14cb5e82a35682256328dae8f3db97e5f033c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb2714431b748b57fc23c1f0696f207af1035009145e5bed136a42610da0bb88"
    sha256 cellar: :any_skip_relocation, monterey:       "16d3bb600c4cc99ec943a30b1e631827be925152a6b86941808be4508aa51d26"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9984c18bf5dc7d557b1ae37de616437e735af26beba68539e8cbffe59d9b472"
    sha256 cellar: :any_skip_relocation, catalina:       "74eae1fcf483bcedcfe06f88af6c8bb7c84c5ab5699b66e22783f99ef7921972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0538fcbb1e4c8dbd20dcaa5ef5837aae9b648d76b06e20c55cd548d251371a1b"
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
