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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9555810d9084eea8128d8f9798d0d628c4e033adf093d475dd3e2f32521d3926"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47bd851f8d7b41469a7fb7ba4c320a055840931f238d99e1456717f1136b4460"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "28433a1ca9e337b2fadc2af599ea4036b37b9d7728ddc125cd0ab5f794f58639"
    sha256 cellar: :any,                 arm64_linux:       "b172017474499bb6c486eb4f86a41ffd45126f08976d2cc8218147a231ef6614"
    sha256 cellar: :any,                 x86_64_linux:      "8df1b97dc20e77fa718f9bd391d3414054419bced51fc8ee6ea93cd8321e7972"
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
