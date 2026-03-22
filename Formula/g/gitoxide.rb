class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "22da356497d22eabb598233cfba61db3674e234792df1def55212ea7d2793e5d"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15c127485e5f8955d33827e2121befb81ead4101744b44ff2c13b9ef8efe30da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "795777e6bf2b2a850221bc1a488e8fda61b789ae0e4456828dd9b794511e4a1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5485f9ebbe11dd1b1de5f5cb28a83dca2f8408e62d09b69ba0426cd20ea515b"
    sha256 cellar: :any_skip_relocation, sonoma:        "666d8a86eec3ca298010b45126bbd13cf63b6e494edd8f252fbf155775b337de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5df20fd3cab9d910947b35a143d55c3977cdeb7f5122051f53a3c1e1db52a98e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "548ccfdaaecd13e50ced33fe924531519535947f8eb58122086a6d53752226b1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    features = %w[max-control gitoxide-core-blocking-client http-client-curl]
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
