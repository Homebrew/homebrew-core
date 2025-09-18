class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.15.5.tar.gz"
  sha256 "6030613dd02792a10b618c4642e53ede48720dc12ad6ab9060aa0ef8a27964aa"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b10f39a09af7f097d44bf74be49cc93438bfe242ce44cec0f3fbc6ad70d721f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94457770b0b768f1506edcfd5e3846a90860021b2862b58497015ccc0d84bca4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e4ceb751f38d85bdf62a5c2eb45c99d0321083161c26db8818e989a674a2792"
    sha256 cellar: :any_skip_relocation, sonoma:        "6172b1d26f277ae7db5505a1542f868b29365d48f0051ef40f208776e943569b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "412e2be54b03e2ea25178ec44d65eaeb24c0b91aadd2253f8c4391b4fe87a70e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02899d5aa9537f352f19e4436cebc245ec25a209fa2c0c60e9c6f2e172b21365"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    ENV["BINSTALL_DISABLE_TELEMETRY"] = "true"

    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end
