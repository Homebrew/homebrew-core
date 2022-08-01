class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.538.tar.gz"
  sha256 "8a1240e02a7daacf1e5cff249040a3298c013157fc496c66adce6dcb21cc30be"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8929ad274e7e292afe92af6d448d705014b57751b49a0d9adc09a79147d5993"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ffa1b7e0bd5950a4b1bbf517504ad2abf51e391c33c3fcb7c00f5512bd74414c"
    sha256 cellar: :any_skip_relocation, monterey:       "b41e5884b3e79b93393cd273cc979446c5601b67b6240763f18e24583ad2bf58"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d628a2a984d3fbf4e3e1052197c10ddd2d7c64f6c2d5b52e50b87b620e02f55"
    sha256 cellar: :any_skip_relocation, catalina:       "ba017f42bc41e4aed5a0f162e28cf7a61cdd4b62ff0eeef6068124837088d87a"
  end

  depends_on "cmake" => :build

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
