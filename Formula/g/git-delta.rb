class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://dandavison.github.io/delta/"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.21.1.tar.gz"
  sha256 "2fc82657d692dec135fce408b3f20c9ab6c23198ed35a983e79a04c5fb133f04"
  license "MIT"
  compatibility_version 1
  head "https://github.com/dandavison/delta.git", branch: "main"
  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a5d5b16bfd7baad93e65e0306f6c42db2d939aa5ffb3aa8ef014d3d06230acdb"
    sha256 cellar: :any, arm64_tahoe:       "59beaefdea72ef7f84014aa10a378d1c92d6e59b53d7a2ade35658d90a273fe7"
    sha256 cellar: :any, arm64_sequoia:     "b25feb6fcf4502ca0f3bbbd56cb164d07d19dd9b5fd57d7b74c9438ca50eccdd"
    sha256 cellar: :any, arm64_linux:       "d50ae7a1bf6a802bc9ee9f36125939bc8dfb45bd282b71ba5e282848cebba313"
    sha256 cellar: :any, x86_64_linux:      "dd4678e77f1be79a7f59f7c153a38fd1d40debc9116422a1dfffc4cee2cd21a8"
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
