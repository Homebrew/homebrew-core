class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.748.tar.gz"
  sha256 "810b13d1480a7a2efa66fe356d7e551d2ba3548823a69a4df5a6597f2beb35e5"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "233066ac8d11defb9e593dde1c3077158d8b1cd94c61716652d67b097bb8312d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f34e4c091c3f92dbced9714dae2aa741e696ece83e707cbf45d491facc8e81d1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5d40835328dd45d465b1540efe4bdf58d8e3d73a592318b0fb2b4f62cdb6dfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63e31660eeb5f1d30f9bf43159e777a0d5e9c425277f7211a1b4024fef2dce41"
    sha256 cellar: :any,                 arm64_linux:       "b9c93cca96addd2e60a18ba6333cca9a66cf66f7fe1cd7ad62520ee198e7b141"
    sha256 cellar: :any,                 x86_64_linux:      "e3e30d70741612b0dcaaf160b5b7ceb880a5a4d5b6bdb7aa610d473eba19d450"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
