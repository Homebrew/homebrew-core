class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.517.tar.gz"
  sha256 "d367a92fc90a1e9b9c1693110208e3854e73cb88db75161c3bb74db9244430b3"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8022ac74fdeec03aa48434d050527589c6f7ccc5a4f4b440f125e2af1210ff3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbb408e9f7520b152ad62a66afb1d40a08fa32ad98465f7f53bbb11760c4738d"
    sha256 cellar: :any_skip_relocation, monterey:       "331a3012b49300a5f88560774eb8078c7c57835834813bbe61ffe815d2b2fc70"
    sha256 cellar: :any_skip_relocation, big_sur:        "c67e62b62dc33654188b6dd7401aaba74a0b85959f7c9d4fa821e8dc6e218913"
    sha256 cellar: :any_skip_relocation, catalina:       "05b10ae7410d328d57ebae7eb3a08ef02ad2ca934845be647dd817158ce5791e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29cfb2d768b864af53434f9e6f25ee6f300cc4365aa921c8c64856f8c405ba43"
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
