class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.62.0.tar.gz"
  sha256 "7cd2a69315402cfec90b9ab36624645ed595c7cede95fe4e0f295624ea736383"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "8df6b5e6ab9d5dd5ee34a20fc876b69f40188b32ab0586a7076447fcea2be461"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "49996c142cc7ace070d08f488ade2823a37dae49b7c0d6a332c0c23700bb21a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "29c3ce60f807218418fcd6c2dd9fb9083d19f4508a86c8ad99d44ac7b1c37477"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d3e169cc1d2f33f7e3da002fdac1a537bf1ec7e3e1f624355004d57f2258ab78"
    sha256 cellar: :any,                 arm64_linux:       "6722e23f6c5d4fb42b57fc4e5e07d01058690d8cc641112b00a43c5a0868bd28"
    sha256 cellar: :any,                 x86_64_linux:      "e381b535cd2230393384a394aa5cedce88db8f11aa5c8ab7965777ecfb696329"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    features = %w[max-control gitoxide-core-blocking-client http-client-curl hashes]
    system "cargo", "install", "--no-default-features", *std_cargo_args(features:)
    generate_completions_from_executable(bin/"gix", "completions", "-s")
    generate_completions_from_executable(bin/"ein", "completions", "-s")
  end

  test do
    assert_match "gix", shell_output("#{bin}/gix --version")
    system "git", "init", "test", "--quiet"
    touch "test/file.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}/gix --repository test verify 2>&1")
    assert_match "ein", shell_output("#{bin}/ein --version")
    assert_match "./test", shell_output("#{bin}/ein tool find")
  end
end
