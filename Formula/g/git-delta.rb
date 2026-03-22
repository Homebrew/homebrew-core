class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.19.0.tar.gz"
  sha256 "cb11c5fb6514f94b6bb3bb6a163ca3653bdd234fcf7aa0c71b0861e77ca44324"
  license "MIT"
  compatibility_version 1
  head "https://github.com/dandavison/delta.git", branch: "main"
  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7987efaf4b495f82970595b8c7d2db16b3a3ffa05bf7f0427ad0055ea87e270"
    sha256 cellar: :any,                 arm64_sequoia: "a18e310835a64c36a39c98a29199307535ec224c28f2c5121b2313a1c6cf3397"
    sha256 cellar: :any,                 arm64_sonoma:  "b4cfe799da7c545089d44d1e878c14822fcf9315905f2358c11c08e6771aa2ee"
    sha256 cellar: :any,                 sonoma:        "99d1589e3caf1b5b114f9c2f05a8406518970bab98c6305f722ec47f8260730d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2e14e98ff5ffbdf288c1de20624871f703ec0f67be373b3fa159286f88a0f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9356b979049c6ce9c6fffe42dc3087df49753c55cc36e052ac140fbd50a6457a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "oniguruma"

  on_linux do
    depends_on "zlib-ng-compat"
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
