class Prs < Formula
  desc "Secure, fast & convenient password manager CLI with GPG & git sync"
  homepage "https://timvisee.com/projects/prs"
  url "https://github.com/timvisee/prs/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "4ee5c981a1b6ab0943d6e390c72cd1f339d872982e838299fa91013d9285a53d"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "88c084931f05e2e15d615c7131414d9b2e9aa6e67d1022d533213f558b62aa18"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3026eb5565077f4eccd703dbf6321bc55ea46f5b1963443e8e7b4f42582b514d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "72310b68e7fd528a0cceaab71c4884cf7cac7d697e563708228613604d439680"
    sha256 cellar: :any,                 arm64_linux:       "3a54851ffd25a365bcbf3607e0b2add6590a867bd5eb14b0557a8887e0766c17"
    sha256 cellar: :any,                 x86_64_linux:      "f6d41d4551b4e01478b7544b0b49842f08c66acb5e955e69174dce9d5bec0b6d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "libxcb"
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"prs", "internal", "completions")
  end

  test do
    ENV["PASSWORD_STORE_DIR"] = testpath/".store"

    assert_match "prs recipients generate", shell_output("#{bin}/prs init --no-interactive 2>&1")
    assert_match version.to_s, shell_output("#{bin}/prs --version")
    assert_empty shell_output("#{bin}/prs list --no-interactive --quiet")
  end
end
