class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.666.tar.gz"
  sha256 "de22ccb3f76bdf4875e70c36a99ebf0cd2ec7409d9d2a5d61cf68493e59eedba"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6424c67300d71b48fa29401eac3ae8ddafff9ea5359227486de1d2a37f3e7d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "627f84658d933f102c14db2fc35933628e6298e96354e1c7c92e711093cd9d2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12c198d4f4463645ff0ebfa76abd04a5f75df440c8306afbe7c6be9417664b78"
    sha256 cellar: :any_skip_relocation, sonoma:        "3925ac7a1617f86d917ff648d0881814e3889c949cb9ab4294083cdad629b647"
    sha256 cellar: :any_skip_relocation, ventura:       "76e22364973f5694c299f3a0a6a20faa56c808f2dcb966ea614ff876d895e78b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41dbbee847f53d11463488eb379c61a027558030f254cdf89d55b8e6ec8877cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74e6a7381c27d6c203019288663d0684ab2d9a819e367f0f48e09686c1538b63"
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
