class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  # Download from a commit temporarily since we can't untar the tagged release.
  # This commit is the same as the tagged release but includes a fix that prevents
  # us from using the release tag. Switch back to a release tag tarball in the next release.
  # https://github.com/Roblox/luau/issues/373
  url "https://github.com/Roblox/luau/archive/a9bdce6cc06577cb412c38db757e44ea783f7c05.tar.gz"
  version "0.515"
  sha256 "6234ea76f65f7f7eaae2e285dd834dbfe64a58a8aebc4e4681654dd635b35dfa"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "776a8d69931199925fdf31c27cdc66beed9f4840cdd0d30a2104a7ac58d56a17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbc798250646cd1f1d5cebfc6305d361bb04ca6abe4bcbfacbb73f97950c4952"
    sha256 cellar: :any_skip_relocation, monterey:       "3ff256b119d6e88693d5d36e0e2c5f637faa8eac5f3013065bd2b090d3afb7cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f3b5fb8997d1f5c8ebc84731bafbf16c641d784f49f17852742d79207eee5ac"
    sha256 cellar: :any_skip_relocation, catalina:       "c8edc01020b94967eb34372575e6c4d473967343374e5d35a1a384fa6efd5089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39c87edeec1804ae09b025dcdba3395108a9376b7145d6ac1204ba047242d49c"
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
