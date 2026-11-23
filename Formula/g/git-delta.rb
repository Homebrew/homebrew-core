class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://dandavison.github.io/delta/"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.22.0.tar.gz"
  sha256 "71fb0ba85058a8f206f11ea227d2f940f6051c9c81dcb238935e10b0dc82c09c"
  license "MIT"
  compatibility_version 1
  head "https://github.com/dandavison/delta.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "6b6ee0bdd9b3277e23882b6c7d34274b7c6489c53ddf0b96e8ee4de9fa12f388"
    sha256 cellar: :any, arm64_tahoe:       "2f2ede3e37bebc31b71937565d71694ebbeca818a9799e6fc61f73ee8f39ebea"
    sha256 cellar: :any, arm64_sequoia:     "66fcbc318b7593174448715e3d41038d23f75ea78e62052e90b7183f80fb00be"
    sha256 cellar: :any, arm64_linux:       "217e0588109f6154cfc16bf17229910e0b867dc774c1e90253670ee36d8f2770"
    sha256 cellar: :any, x86_64_linux:      "7a37d0b8026f6df74bfa4b92f11b715af21088bf6edfdcd1bdbe1bc7c9a40d04"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "oniguruma"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args

    pkgshare.install "themes.gitconfig"

    generate_completions_from_executable(bin/"delta", "--generate-completion")
  end

  test do
    assert_match "delta #{version}", shell_output("#{bin}/delta --version")

    # Create a test repo
    system "git", "init"
    (testpath/"test.txt").write("Hello, Homebrew!")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"
    (testpath/"test.txt").append_lines("Hello, Delta!")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Update test.txt"

    # Test delta with git log using pipe_output
    git_log_output = shell_output("git log -p --color=always")
    output = pipe_output(bin/"delta", git_log_output)
    assert_match "Hello, Delta!", output
  end
end
