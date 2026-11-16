class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "72c07145c40fe69f40d7758644b50788a09426ae524c43a5aef3b16ead3b4bc8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "803efcd565b3824b4f2b2876cea7efc0a7792823f2afecd64409e190bcc3f897"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1163adc00d8873df6b3efc5983c5c6fd27df7d114922079756c879ba50592977"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0fcdae15902a834b52c7458a944a61fab9e3252f8566f5cc7cdeb88487923a0"
    sha256 cellar: :any,                 arm64_linux:       "fe150bdb2f8df7793293f666512624ff5778ecc823dc5a425415a3dcb57200b6"
    sha256 cellar: :any,                 x86_64_linux:      "d6db587b30875d684f2a624a1237942b4beaa9b00e945abcf25238614f24412a"
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
