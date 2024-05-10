class Octobuild < Formula
  desc "Compiler cache for Unreal Engine"
  homepage "https://github.com/octobuild/octobuild"
  url "https://github.com/octobuild/octobuild/archive/refs/tags/1.3.2.tar.gz"
  sha256 "47dfbeb5d6fe329dedcebba979d9a6ec263914fd67ef5a75422201eee980e17f"
  license "MIT"
  head "https://github.com/octobuild/octobuild.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c2fe4f90eaf9ffe3a290d47f81a05a699d60b2bc67fc658132f447c41478d9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d136c0c3a958c67476d1d1333aad7aa303eff16a12ab6869ab534e5c07a524f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e20416eb1c9fc069c170d57529c03d7bd33b5e6c0bb02bd262173d2cebf69347"
    sha256 cellar: :any_skip_relocation, sonoma:         "f7c1cb4cc55826b209bfbc5cdb9779693710f6dac5b4e8221508b0dfa027bb6b"
    sha256 cellar: :any_skip_relocation, ventura:        "c94df5fc11ae5adf94fdb266ed91a415ce2ba96d9550fb7791dd81f4d5a00829"
    sha256 cellar: :any_skip_relocation, monterey:       "3d0bfce2524197cdac01fd3e666462163759659261c1e23e48a1acfbcc07d4ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bad19a001894583337d91853a52e988d2417edc9c0a38489c27adc2785efcf5"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
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
