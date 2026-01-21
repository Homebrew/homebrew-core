class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.18.2.tar.gz"
  sha256 "64717c3b3335b44a252b8e99713e080cbf7944308b96252bc175317b10004f02"
  license "MIT"
  revision 3
  head "https://github.com/dandavison/delta.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "702c33af336cc6b1cf1950f3bbba87df652d9310d6880a2779f0be9e8a915f43"
    sha256 cellar: :any,                 arm64_sequoia: "e5572a654e8c6d38a1ca6d51ddffafc83abeb11bdee3a39208fb22371c7eeaf9"
    sha256 cellar: :any,                 arm64_sonoma:  "4af7f1406d4f2e21632498f31d64b2fb7962630c9e7235312ce9bf0ad8a6d2f3"
    sha256 cellar: :any,                 sonoma:        "fdd627e7a918dab21f5ef18f6c9c6454ea15ab13f0dc46d90816db96ad2f72b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f508627daf3121478652a6d704bd9b0a7030c270aa90277fba075ef75480f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b6c3c87ac8377cca7ea3f1da5de9de07d511d88eb68c50118b6ac0f3ab6bbe8"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "oniguruma"

  uses_from_macos "zlib"

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
