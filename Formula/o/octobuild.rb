class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/1.7.1.tar.gz"
  sha256 "74149cdbb04f1b854064345270dd83b85dab3f3a6276d46e2d0a11d53d0651f2"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f127d2f870e05b0ac8cd451bd85f87beaa58d275bc30ae555766fbeaa9ce6673"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e95304df2c60232abf3aed763198f5820a70f405b9fd857ead01680135b5d0f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e28de2bd21191ed3cc1bf3480da02c4e9176ec4991d58fc7eb61d7c0f83ebd80"
    sha256 cellar: :any_skip_relocation, sonoma:        "33612f8a07e682ca29a89d541c17420bcaede31cccc382bef86333eaa792e82e"
    sha256 cellar: :any_skip_relocation, ventura:       "daa1e485d69f56da61fa011c64fc6c02304ce76eb620bf57346fbafc02fb9410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "300255c2f90b74d17ad4abe23ad79e3729e602a7f69d1a0b2bd3d68f2e96eec2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output bin/"xgConsole"
    assert_match "Current configuration", output
    assert_match "cache_limit_mb", output
  end
end
