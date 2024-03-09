class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.616.tar.gz"
  sha256 "ac0622314234a0fc9d8a3983845a8868c1efe2496e10099a7f900be37b4687f0"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "70cf5325b609ff722a2bc3bc2c8a5504f345b5bdf763042e0e3830860d3899bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e35997b725ce48bcbf54662e867392bd207cd718a048d8f5f22af938b9a73b2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba01a54a5353c0a8966165290cf150215dacd80d4ed513766edc389ed32be786"
    sha256 cellar: :any_skip_relocation, sonoma:         "78f4a984eaf9b9695004a978ceb5d9ae37782dd936d14464b7da63673b908652"
    sha256 cellar: :any_skip_relocation, ventura:        "6a228467fb83a0039c8f894b6f5d74356ff1c59b790820fdb1dad78ad9da5772"
    sha256 cellar: :any_skip_relocation, monterey:       "ca26e3c8c6c3e25df0ed7addaf1fe0083525a6b07fe38b02d6f7a4a9ed8072c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cde637c7144b410a9c2a0e9d191516defc125ef2acc3f8e68a4979260c7f7b2"
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
