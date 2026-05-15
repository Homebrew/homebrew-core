class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.19.2.tar.gz"
  sha256 "f59b86f8c8dda4d76a3ba34b8553777a20c3b461646917d8e480fac6531bba9f"
  license "MIT"
  compatibility_version 1
  head "https://github.com/dandavison/delta.git", branch: "main"
  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c35e06abe0161e57beb2d763cb43ce0beccf024613dbcfb92b31a39093b3397d"
    sha256 cellar: :any,                 arm64_sequoia: "b45a48b049ca24a824a3f870a467412e3119dac4746f1c13443082bac9d9895f"
    sha256 cellar: :any,                 arm64_sonoma:  "fa7ed02ac2fcbed7247f3fc58012c5e7cafdc609a849cd4295529c750a5b7df7"
    sha256 cellar: :any,                 sonoma:        "f0aba2898cd9d587f33b330905c621c75e9230ba27f0ed249d0860fd3f641e46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "622e704b1cfc9f303fabce8859215b32ce6871e30efbd7da80084709afa0d48c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ef78e0c387f35781bb09dcbbadee5d2d10c7b21f00e6107962d1843fac73a5a"
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
