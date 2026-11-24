class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "b80d5f093cddcf4bd9c295686ae6c1faa2fde838cafc061aa1b347c84dde3323"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "e1cdb2d5992817d03eaf075b673a7acb907f0debec8051d2dbd997893a85434e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86970bfed5ff959c5454db0bb2502f9df8e4a6a3c912b30f469c8074facc7ae4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c47c0bcbd741c109fe1302cc24bba64ef641cd68e09ed7da21ff2bad6a8eb84a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e76919de9cb11a4d39e74428f5718690901e4a8a01355a7a10fa95c30120cff8"
    sha256 cellar: :any,                 arm64_linux:       "f94636eaedcf1878c4d05e629985ace27911cc1201ec4bc5e34b97ce7cc26b1a"
    sha256 cellar: :any,                 x86_64_linux:      "39682e848b3e64137a4d79555477187b13739467aa7e10dc4ef05d570b0704d0"
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
