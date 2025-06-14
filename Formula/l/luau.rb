class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.678.tar.gz"
  sha256 "3ed02ea5640ed9c2759bac307aa83665cceedf2beedfc3f5c5aa5f0e3683d4ad"
  license "MIT"
  version_scheme 1
  head "https://github.com/luau-lang/luau.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "089b2889bdc68ae13c52b4cd3858068061eedbe671880ef9af7302c1d216f323"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5320bbf1dff94a2840fc35c8910f9cebc6f0d4108c5e017e4202b8df90ceb8dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e42d15c6b4f3ec0a69bb7eead88b9bbef0d6445a6501e7b3e19359038d2dea28"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d035226a701e56dcea59ec690074ca8ed39a15a1951312c92b31d108e1241e9"
    sha256 cellar: :any_skip_relocation, ventura:       "108c1aed15b3658c7eef78c8199856951eb890eccd58c46a04f227b76205e167"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0634e63eebd7f119e579247fc3600afe71d004ab9ca4e8b2938224442a91d288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9ffa77930f582856c14c8b77dcff070bdb6d55883b1f02c8a90e9b42d456acd"
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
