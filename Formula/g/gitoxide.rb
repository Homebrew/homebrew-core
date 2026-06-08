class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.54.0.tar.gz"
  sha256 "865f981e88a645131ad5acb4266bfc369b7d82f9481599d528ef435ef9c9abff"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "756e8f92caaf2197ec078130ee7be34b71a6b3f5e68b144c7207f454a8771029"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "949484a0cdafa90c0b791be194a1e19b744db35e6ce7c85e4fc94a00042654cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c690d9730301f7e8ceb702608d333954248b560a4924c85139c54ed20bb1cde3"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca21a9148462e2e6daca089ac331524dd188c3998c1f6f77bb69ad8f9df0dc65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc45aa829f020273279c2b612cf26d1c48c11dafecd5f355d8aee3f63d7a3d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e4b32e6ff4863ac4e664478a53959119872ba5904cc18da8c44dc664f997203"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
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
