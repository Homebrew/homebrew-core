class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://dandavison.github.io/delta/"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.22.0.tar.gz"
  sha256 "71fb0ba85058a8f206f11ea227d2f940f6051c9c81dcb238935e10b0dc82c09c"
  license "MIT"
  compatibility_version 1
  head "https://github.com/dandavison/delta.git", branch: "main"

  bottle do
    manifest_sha256 "cd08e50471bad573536d11be06850900fa2c2a95578921708e4ac45f379ca02c"
    sha256 cellar: :any, arm64_golden_gate: "715b9d12735fead0e9842d0daf780e4aff0a99b8b6fd00c840e0c278d9541ba8"
    sha256 cellar: :any, arm64_tahoe:       "8eb52fafe80ea7f0c0a56db0658225d6b1a8c39cb00fa125659f9cb33655ee38"
    sha256 cellar: :any, arm64_sequoia:     "75cb4b64696344f7903a293237e0f5f2c7405ee03ce2154d535fbc92a45b5918"
    sha256 cellar: :any, arm64_linux:       "ffb46520ad6ede0e5685323f0eeaabb3ca35cd9717ceb355277aa483bd150289"
    sha256 cellar: :any, x86_64_linux:      "9e25553247592bfdd39090771e877f31856fad4df9205a4f9e424d567e150565"
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
