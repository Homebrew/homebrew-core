class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.18.2.tar.gz"
  sha256 "64717c3b3335b44a252b8e99713e080cbf7944308b96252bc175317b10004f02"
  license "MIT"
  revision 3
  head "https://github.com/dandavison/delta.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "f3559522f4412c5ef418e3f79d2e4a438e603fbf45940c4f83acccfcf406564e"
    sha256 cellar: :any,                 arm64_sequoia: "4d2a7c8b9fcc067ae569a7297cbc362fd6c2b0ef4efe30bb2b78085e0bfa622d"
    sha256 cellar: :any,                 arm64_sonoma:  "ac112da66076676a8999c9676699eedcf3ba16c2fc764996a93874c8790cec2c"
    sha256 cellar: :any,                 sonoma:        "3c86f88322008a32a9f93ce98f0da59a2d5e5042d4f87722b9d396393a3c1f36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaff50ccf9af8b738bed04cc7d222014a0eca828e8754b598b3bc767a5dfe8ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f7b957d7e7ba089db5f3561c9b56b036f0c4b03a2bc15de37db29a2a26d8f3e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "oniguruma"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # support libgit2 1.9, https://github.com/dandavison/delta/pull/1930
  patch do
    url "https://github.com/dandavison/delta/commit/9d6101e82a79daecfa9e81fa54c440b2e0442a33.patch?full_index=1"
    sha256 "1967b73aeaba44cf96a3f2866d436449668028d6f8a6fa77dbc0d5c3c386c0cf"
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
