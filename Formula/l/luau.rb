class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.613.tar.gz"
  sha256 "f6d6811ad03f49d46f57d700ea182839e7971b515400c332635a7d1cc62ddc6b"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5d006bf61d2d58218ed6906ed731ae20c95aedebfe5715a002a92435e7ecb8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6665ac40607cc63571366307f9f832f331eae9180114c1aecefec6a528adde8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b91b5e45ae0ce5cd8b5e161b0e08395d8121a5685b61a2fe4d81cdc845d1ba1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4826ec56821030b652928d59431eab83a40bab6d5c4982e7b59852ee35c313c"
    sha256 cellar: :any_skip_relocation, ventura:        "5f4480401d02af4746c38a7e2ab119c18f3edf8b52c23d352f3327c40b1d2b2a"
    sha256 cellar: :any_skip_relocation, monterey:       "6d77ff118523e9cd696fda19470fc179f59c3c1b79fc8b9125e507efdcbcbcdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9c8bd169ef5a056811f2dd9e3436f679a86c8aae2ee398ffe5e7c44f084a00d"
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
