class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://dandavison.github.io/delta/"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.21.1.tar.gz"
  sha256 "2fc82657d692dec135fce408b3f20c9ab6c23198ed35a983e79a04c5fb133f04"
  license "MIT"
  compatibility_version 1
  head "https://github.com/dandavison/delta.git", branch: "main"
  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1c6dfce8d155c888d2b3a7a7852c7fbf8e70f3d506788c4ea83a459671a25fbe"
    sha256 cellar: :any, arm64_tahoe:       "900db86fb42d7d5e3852b860fafab4d33289ca784cb26171efe11763eeeb37e2"
    sha256 cellar: :any, arm64_sequoia:     "cf76efc9d600030ffbb90a518b407d9f3c0672a546f06498bc7dcbb264a447d6"
    sha256 cellar: :any, arm64_linux:       "804c01e3054789dbff316acbe726eb8f9d7be0f59aeb86e03f13159730e2c050"
    sha256 cellar: :any, x86_64_linux:      "5d433f8857c8b1ec32b3311692b452a4e93a86bec45afb7718756bb99384a89d"
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
