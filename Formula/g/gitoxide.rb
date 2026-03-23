class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "8c4edd66f19e9c672040f8a4f76de5f3feafff5c443fc54554ae142a36bc10af"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fcbc1b1f45e44cbabd0dc7e49ec38d15634fdfc010cc8e2d84efc7d4255c5896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d62b3680fb49e321fc4bf1d5a3557347bb1f3a27e5295b50ef54ea7c2def2d4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37172e4bbc32fafb3831a3dee1fa7c54cf4bced044cedcb227cbec63eb594de6"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe3ca99efefbf69c3f5d0fb3c7b127f2bde97a36811b225e935a548b817d3fc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dbeced411a62ffd597b5444bd8f0849e6e58cb090ac9a5190427e1cdb9963d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dafac43e8540a3195e884b96ee1376c987ab57b9bf69cae9f5441c0a9346218"
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
