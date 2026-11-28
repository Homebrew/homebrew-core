class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://dandavison.github.io/delta/"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.23.0.tar.gz"
  sha256 "ee7923901d85343cd44133da35de30ec050fd5c67318c416f8173990535c54fb"
  license "MIT"
  compatibility_version 1
  head "https://github.com/dandavison/delta.git", branch: "main"

  bottle do
    manifest_sha256 "78d39012c3d5f64a0bf86a1470e314c4ce3c80e37cbcc1c20479047a5bef787b"
    sha256 cellar: :any, arm64_golden_gate: "83dc7cf04fef0e7645f660d70dbc66141d8d57c1011699b957f7e4a9c1b9980d"
    sha256 cellar: :any, arm64_tahoe:       "ad0866614070a36bdc3cc025ecfe302f223a140a8a76ecd36dd52611c145a91e"
    sha256 cellar: :any, arm64_sequoia:     "b2bf3e36203eaa0bd1b626f8cac55aeffb05d4d87b8df38d0c94365f17036413"
    sha256 cellar: :any, arm64_linux:       "26b9530c120c54af0fb1f9cef6666caa0086e80535a5c351e724ee2d81a838f5"
    sha256 cellar: :any, x86_64_linux:      "2e012d02d91649fcd8ac442f9b60a80f5abaafcc55a667ec71fe6581781b6db5"
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
