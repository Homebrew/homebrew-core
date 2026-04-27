class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.52.1.tar.gz"
  sha256 "47eeb05374986e6a3fd174d364ca6699bdc58966f091ff8ab14792a87629c499"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dcacdfe75f20dd268a17fe5ea6c61f0b8571d705dfb5505abeed01062e3222d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca8bc9245d58ae5c858222450956805841de712f160d4ad8dfe4d2cb16b4d0c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad6e1cd8b4249016afb8b38461e982ffc115e65af0c73a84067d00b02cd3541c"
    sha256 cellar: :any_skip_relocation, sonoma:        "412825658de28377ac8afc3f767d12ad15707a91b86221da58e2a13e8bc6372f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "196b53908bcd69f57f575c77d5bdfec672be914556357ebddfae3f35b12af36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1834ae5542be6b7a9329f78cdba587c6c02bfdf41a5444e108505df4e645ca55"
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
