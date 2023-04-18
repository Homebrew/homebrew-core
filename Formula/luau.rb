class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.572.tar.gz"
  sha256 "5cdd13233eefc4b3f27970118272254a24be81fafcccf60e7a29391fbc529151"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc6b63d13d453d4c63f83d55363bf542e948bef6e8f99886cf295e758c929b55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56f365bd788ef98389e3fedca18887fa4f9051a92dda90dd4c5aff37189f656b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25b3ee1a46fd66cbc1b3142bfe2e904c5bfb9df4cb48a725dafca05ea5dabfe6"
    sha256 cellar: :any_skip_relocation, ventura:        "3e86eb951d44c683a0f99a1e72f8a1cb7cad72cca19add18fed834d9506abb24"
    sha256 cellar: :any_skip_relocation, monterey:       "e21a890102acd407381c5cd0c2fd3b16a8e20d919e6e1789b935ae3905c10074"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cd7d59728709cebf852daeebf92ff76ffcd21bf5435e7c384532d32f99fcfb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89009935e4ef119929b319a7da63635c2b4f16eeb740b22ced0f1ebbdfd744e0"
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
