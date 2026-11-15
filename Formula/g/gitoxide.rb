class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "52eef94ef7a4714189fc3c77a0a345a4f61d2e3b5a4dc472ea11115a05c8da40"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0067c2179b7c227ff5015ad4c2dd9d2a3177e6cb9e376277513d15df0b6af853"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "adee20a9f820f8b406b8a134f105e1ed7267b5b1f021ed46438810549d3b34bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6e55a629cdd294c6134d396286b9516911d3aa6e6126d52bc821cd979c4874b3"
    sha256 cellar: :any,                 arm64_linux:       "ba652bdfb8fbd2b632632dacad05f49b7c1618505b20a7496186128031e5804e"
    sha256 cellar: :any,                 x86_64_linux:      "be3549eb824b8bedd5fdc67349a455cba300b3a13077637c7fb3b29937afc5ff"
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
