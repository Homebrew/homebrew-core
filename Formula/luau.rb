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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf5d26b7511f3315647e4091c2148a4b58a1761aa83c6b777b47209535f6b9ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8e5d8d13fb3bb0dd514f39c5d52137e8c07f7eba7d32529d4015c41a9b3f98b"
    sha256 cellar: :any_skip_relocation, monterey:       "900d6c7f2e7e6d1b9be6e7e0085e18905fab3a4b9609097a506c8d140bd5b98f"
    sha256 cellar: :any_skip_relocation, big_sur:        "584e4b4cc5445128ddd4dce02beb692993588fef08de3a4d6366b3bbca00cb45"
    sha256 cellar: :any_skip_relocation, catalina:       "0883e52129f8a6cde2e29308c997170207735b1d100f692917c3a6c5a8609fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17b2810ba26c8a81138c93460a1f796bbbbb0de696cbe726196cdf21b4efa51f"
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
