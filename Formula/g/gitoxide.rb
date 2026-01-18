class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "190d8708ddcd27ca6c1df264286a1115343bc324d210f07eeadcc3a110abfa8c"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2759de57b5ed010414266451499e6ec6af2141ca87ea2b6c4596e7d4801da35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1186b86636a86949f42bb7b4cd703c65308df1dcb7c828aa7959b3c5b42ed207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28f9f2be81dadaf8c3947acacb48c3dab13612c6ff13790949c7346ff2b82813"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6ce97ec6f511f03d6a94a5d0a0684aaebc20a6de51b5b227dcda278104187f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d217e4a6bfc39c64b9a9ebbb70dd8f9d4e86d3c469891495e3696a1fc5631792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "327f4893b63982cde702fa26f6933d66d468a9df49ac62a10cee9435c8d47a5b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    features = %w[max-control gitoxide-core-blocking-client http-client-curl]
    system "cargo", "install", "--no-default-features", "--features=#{features.join(",")}", *std_cargo_args
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
