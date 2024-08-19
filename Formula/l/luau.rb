class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.639.tar.gz"
  sha256 "99317e7f161ed7eaa68a7eb1e4ab203341945c03e67e002a2875793ef1ea45eb"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cfff098f6d64ac5c97df414e897f88bb1b15d7dcb75a39b1c6c8ab9bcfa48490"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "483691e0ddc8f46596663d03805131164775690d02f1f40cf906a78ec2462dbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b4c428da827700cb6c5674750db6f13e38238dc80292c14904f08090270a8ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "22eb76656652a8965bacccea8b77bf7fa8ebe3fd077ea62df16ea18e28a277b8"
    sha256 cellar: :any_skip_relocation, ventura:        "1ff3a9f1db934991aa6cee86c2a251a10fad0ca34ba80d538d9d92f12592fcff"
    sha256 cellar: :any_skip_relocation, monterey:       "7ea4dadaedf33327796e7ddcacd72a0d412b7f91c9730d01b7c66b6f6ad4d3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64a24e9bdff5628563d575150aa6cf16429fc7790321d7e870b950ab853f5db5"
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
