class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://dandavison.github.io/delta/"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.20.1.tar.gz"
  sha256 "d9d502396e3595ee8fd926f1ed2e54ac9935baabd3569a3753efab36304f90fa"
  license "MIT"
  compatibility_version 1
  head "https://github.com/dandavison/delta.git", branch: "main"
  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eef3787a3012549d0a9c4856c7b00c6561ff08584602bb4b64b66936fff7b371"
    sha256 cellar: :any, arm64_tahoe:       "d1d9800e94e7c33ddb4ea7ce06c7f2d1c7291cd12122052ac3daf6f33077c4a0"
    sha256 cellar: :any, arm64_sequoia:     "f3975ac53be6faf0ed19cf845eb6d27427fcd6b60952dba9c7ae7ea6efea7bf4"
    sha256 cellar: :any, arm64_linux:       "c81af049697e49b2b0b88885d2570d6904ecf7e13bfa3a95a30633f00d7206fa"
    sha256 cellar: :any, x86_64_linux:      "b5edecec565ee4def3af4f9df5fb1867263097a7bd3ad73dd83ef203a618f033"
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
