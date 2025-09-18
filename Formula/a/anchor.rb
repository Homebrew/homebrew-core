class Anchor < Formula
  desc "Solana Program Framework"
  homepage "https://anchor-lang.com"
  url "https://github.com/solana-foundation/anchor/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "0c9b1e3e1f14e78cb00271171b1cfac177c7c887814b022196bcbf7e2389e089"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "318ce5a652b7547e9b90361b2d16d9c379fdefb7e3a58cfd5ff7fb039c3cc410"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97816dc2352a8936ed7afa38803abe519939b2be4dc72b82c968a4f199a08f38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7a859fe73e707cb3f44839285234a7687a1f24e42b934db66d65b096ab2d335"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca4ffdfb9aae0ff812731a31069abd21513c73f62ea515987c5f46eef69cf7e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eb7eaa89f2196a477b656fb3cb49a4266c6304e905ac33e9b7d747c6bd123b3"
    sha256 cellar: :any_skip_relocation, ventura:       "066844da5df515e3839334c969b030b9301dafe6f567b08f7d550410a57a5aad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "872bcc6d409302f716595e7bc6707c46737548ef649da6bc13745e38cc4bffe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da2bad29f4d7784c6ed6ef79c00a6120963086dcc9ad17fc98e87bd7465d6fe2"
  end

  depends_on "rust" => :build
  depends_on "node" => :test
  depends_on "yarn" => :test

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "anchor-cli #{version}", shell_output("#{bin}/anchor --version")
    system bin/"anchor", "init", "test_project"
    assert_path_exists testpath/"test_project/Cargo.toml"
    assert_path_exists testpath/"test_project/Anchor.toml"
  end
end
