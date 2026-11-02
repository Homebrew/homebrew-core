class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "325d744270633bdc4473a93523ce3329f149f9d8eb68cad459e8081548861219"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3f4540c1a00ae13663541f3e6d4b9c933f7036e2672b83c897a701dedc2fe97c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a03c054c6cca31983c65716b938098f69dd5e853c4d8d27cf8e36858bc5dd699"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d400447dc6b7ab49e9190995295f793b551ec4bf286538b4c90a0173f7ffd9a"
    sha256 cellar: :any,                 arm64_linux:       "562d7dce9cea4e4ff648482971ac0a0b9e3ece939dbba6b41c3b627541453445"
    sha256 cellar: :any,                 x86_64_linux:      "990d70e75b35a9848323c642366a80572f4459f21536cfd1ba444c1d90b5326a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  # Test installs a package from the npm registry
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end
