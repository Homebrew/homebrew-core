class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "157d04293f4a84387ac0aa36f4b080d1a47f4e69dae2ed13c058be076a4c467f"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c5ed731e91a499390af6e134a7585916beff6a21cfda8e28b112b15a3617c27"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8eaa5ffec502f542b517f13c8799c77d8480497ff3b957e6e2ac56131022087c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b5444afe7864abece17a9eb76a59996c73bb5187862de6713244faf4f983f7ee"
    sha256 cellar: :any,                 arm64_linux:       "407fb9d9f9c384bbdb7428d74cdb3302274d7739bfcdbc6e76b0ed2be11464ec"
    sha256 cellar: :any,                 x86_64_linux:      "be41f544926defe500f11a70877b2940d34eea401b439d4c8e29db4356a6acdf"
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
