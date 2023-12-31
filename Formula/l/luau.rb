class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/luau-lang/luau/archive/refs/tags/0.607.tar.gz"
  sha256 "519409d7dbb43da13390131a90c831cb0f2ab9c25e337acf15508313a339bf36"
  license "MIT"
  head "https://github.com/luau-lang/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51eda54562f57b4afe503feb38c67067c09bae6e2a21c767fb15813ba5ff1232"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7bd122c3ac373f968f08b6925b2d6e3ab46137b996a8e546d56c2af3011b2a40"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5526bd0763f2c12b61d249db16da84f897df3653adb51733b9d19b920710f653"
    sha256 cellar: :any_skip_relocation, sonoma:         "15663b4c770cbd078070a4108268de84ebca4854d2cdde97ac7090e83ac25401"
    sha256 cellar: :any_skip_relocation, ventura:        "b1c9df13a573110c1c7ad829786653f955066cc8c28aea3771e66801cd76d6b3"
    sha256 cellar: :any_skip_relocation, monterey:       "dceed664a68cdb08ec4ca645e826d1bc6e0a6d96ca6b2019e5a686da8649330d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11a81533b379357893759ac038b911677bd0ef22cb6244870fd81263d01a2665"
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
