class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.617.tar.gz"
  sha256 "5de17e264e7ce56c6ed383d7127a4a54bf6ba9ec24fc259c680466cd39b277c2"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bc7cb492a60651b5d6442f8ac9b3cec2b890886eb6e59f27bcc98b68ecc35772"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d506c600abff6b4c8360db39fde6c49f6052bf33827416c70096fdad3fd99484"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2be0d69698169f80cfc8d5174cf2bebece015e72b4e13708d28ecd65124470a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ddb77e6a175ca54a3da58c3193a9a8f416b5e5b7f490a79db74c3725f4d8000"
    sha256 cellar: :any_skip_relocation, ventura:        "85b64b114af36743b92efe7cb45948311623beb9188377d0a8168af2b6e4d29f"
    sha256 cellar: :any_skip_relocation, monterey:       "2d36467f5e83ed105ff7b85cfb4a0b3b7cafdb1d6ce2872e52ba3a5a79cd8c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9339d84b58211ef375baf2d0b45cd966f0a6cb605951d28c069c9864f45b7d2a"
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
