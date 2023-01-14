class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.559.tar.gz"
  sha256 "fd29b6f9158f6e2cc868df0077c572fbbc70ee263642b6215763b7128a2001c3"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e23570aa08b7afe327abdc2286d8906abd96c9b32756466c8c140bf8aa756bcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a8e8c3f005087b03a4ecbad2d7322e4ebb49313fdda8793fdfa1d6e6850279c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee9bb89f21c414814d3d444a35f2fea6499b10e385f55d83cd2c01b39f7e730f"
    sha256 cellar: :any_skip_relocation, ventura:        "ca7625474509b9825358463ab1e5c91d63bd86a8432b059179cd31d321a535c3"
    sha256 cellar: :any_skip_relocation, monterey:       "c13c39fda5015949168bb62fc93191ea3fcad773c746f334ba126efba6e30f58"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3abd141d3200dbea395e079a16eefa5ecf4c66d80a2bd5073d926be04272656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e2176d337d183fcbae603d6489d4a5f4598a5e6dc9b83a47ae03b662c04797a"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DLUAU_BUILD_TESTS=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/luau", "build/luau-analyze"
  end

  test do
    (testpath/"test.lua").write "print ('Homebrew is awesome!')\n"
    assert_match "Homebrew is awesome!", shell_output("#{bin}/luau test.lua")
  end
end
