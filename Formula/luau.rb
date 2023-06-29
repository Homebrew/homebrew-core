class Luau < Formula
  desc "Fast, safe, gradually typed embeddable scripting language derived from Lua"
  homepage "https://luau-lang.org"
  url "https://github.com/Roblox/luau/archive/0.582.tar.gz"
  sha256 "ee6da6329e58afc956bcca907ed9c6bc0455cd580990aa73f7cfb285aea22a6d"
  license "MIT"
  head "https://github.com/Roblox/luau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7185cd4b0745a8da6b4d07f38b13e1f8f7c95e02733fdc0970f5012c69a59dec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2013d2086e8c9cc34f89966196f430103a5ec67dc4e0e6faf3e8a8e2c42fcaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10b98e94e539d259dadaa09fe53db498a91ccab9c93af97bbaf9cd1e9e32d393"
    sha256 cellar: :any_skip_relocation, ventura:        "b26eb0990d3d6d74896c4c5c207ca41ee1c05989c1d2e0583b51dc1304a52fb4"
    sha256 cellar: :any_skip_relocation, monterey:       "99551038055fe7f8453759a352b3b6a9b7069854fc705934bfc5e73db345d127"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b80907eeb8f48e3541566e2f945a08c86875ae51f6c28e169d1e0a9f98e56dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d61d0731b464b3b0ed7817601e6627bf80c0e8c8e2eae020a80d7246bdd1e03f"
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
