class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.540.tar.gz"
  sha256 "84b3e52b3b0ccf4d5bc0e0c04055f3a9b2f045c1281e203a858335a6fe76b0ff"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c5afd7ed5548aaef7fb81f3c1fe6a4337fe563a60f9dbade80a459634193612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3de5818c36ac2be11effd1970db139b874be27dfc6617ff9762b6c972a8e6ad4"
    sha256 cellar: :any_skip_relocation, monterey:       "23c3975e4a71ad68f1f2942ae7d705c580c1174a6c4bfe443725f19edd860ec1"
    sha256 cellar: :any_skip_relocation, big_sur:        "f72d42ace815c36e96edc39f7d3a90b98c500291ccff9e09b7dfaed96c853e32"
    sha256 cellar: :any_skip_relocation, catalina:       "8ba60346ae9c627f447ff86216e60fc04e80a304f653dfdce23d9d2b25c12068"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c905b1493be163fdee6f169ee56421b10c29e3086e52f7e3747c7b2baf8575c1"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

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
