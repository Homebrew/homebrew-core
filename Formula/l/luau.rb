class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.734.tar.gz"
  sha256 "cb55a891226d8c70284e22eb9281cc2b4496c709a4050f52aaa18a355fe7b1a3"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdf71280bfe50b6ce33a3da63ba04af0d1b2423817e450399345a999e31c1eda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76658deeaa78fee22acc0502a0ea871c2293db8fe82436fcb52f1edf937cb5c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d9eb039a59eb3ea742c31ce8244689d12e055d33c6b05728c454d6a0032dcf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "caf83e4dd6b251e4ca0ea20c4f6947aab403399572abf3b6f5e6129dad0851c4"
    sha256 cellar: :any,                 arm64_linux:   "18c345c7cce6d0d1dee6f8bf7530e018ee2b268468c578712c4db5729b1315fd"
    sha256 cellar: :any,                 x86_64_linux:  "84514fef5edefadd755632bb30cf84845c02abfb18a4dc4e9ef8aa2f9ddcb55f"
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
