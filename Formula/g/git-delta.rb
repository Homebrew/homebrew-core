class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.19.1.tar.gz"
  sha256 "a2089af1b86264d45a2b5872708701aca4506d1c092be23017bb610af369f283"
  license "MIT"
  compatibility_version 1
  head "https://github.com/dandavison/delta.git", branch: "main"
  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7177bf9406094f5a1002ab58f81ce76be27b54da6b84dfce77f2c42c8dd3f06e"
    sha256 cellar: :any,                 arm64_sequoia: "81e84b3e38d4c68dfd813afeba57f67a0735a73216c4fc5a6b366062e245d253"
    sha256 cellar: :any,                 arm64_sonoma:  "54c6503027859be0a8ab512c65dab70b90bb5c64034df7026ec05e2d0dc264c9"
    sha256 cellar: :any,                 sonoma:        "57a8ab78bd589af4fb229a17c9d8a31bf956746b82d33654f1f9c8e04ea8d8a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f819766b1de8de56b31f7876c9f0eea60fb522c14b1134a524d970c15130c475"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31695c57397af3d1645a14e80913447686aed23718450e1d8b3bd6f5d81ce0e4"
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
