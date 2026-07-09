class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.728.tar.gz"
  sha256 "488effdb5f9ece3e4436ac65fe3cdcb02fabd6bfc7a1af22565ddb83ff03963c"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6334f30b40cd556ffc3872ff683a06a47b7db80853a94f8c1c6e80be82e2c1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff749b2b96ca4ab3bd46852dce6768a86e09b7b64d91af6e05c60fff3170da78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2675f82eaaca6db6cc41c8459cfd41f5f70dfdd3abe63eab8043c4227ff8fb24"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae6161eae14071cf439b357ee651c0891e8479775b2b7532885f6e9362e0fd15"
    sha256 cellar: :any,                 arm64_linux:   "6108e36a3490ce098f4a5e169d90adf7c1388b99951cd228d3f0d0497266cc07"
    sha256 cellar: :any,                 x86_64_linux:  "5d9d0c633e209d80377ef478008da092dcc4c288abcc2b6e07881cbf172027fd"
  end

  depends_on "cmake" => :build

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
