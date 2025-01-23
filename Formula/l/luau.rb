class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.657.tar.gz"
  sha256 "0be60e118c125c74ebe448b0b8141da8bf1ea954a092416e6de451a44bdd6f05"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "343d2002d2617c6bd7b9b34595007e3d367249d0cd4cdcb61e807c5051d409a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9170e0bd4a98ebc9e3d750eeb20cb6b68d9b2139b01d69004e21aabf1fe635e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee33f0ad6b706f7a2f01723caf5a93b1f8cf1f5dbde6939d2c8ce0d1917b53b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "61968bf1c364e7a9712774822ee77ab3745564a6d12dbee1d914515e615b8a0c"
    sha256 cellar: :any_skip_relocation, ventura:       "a6f739fccf63c5d65052b83a283e451dd358c7a2578764c14ca89174aef07494"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "190ca686d58358e71bd9d00520575fb9e14e2905f9ff5be2385c5e54f28750a7"
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
