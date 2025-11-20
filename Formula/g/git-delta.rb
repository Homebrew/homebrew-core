class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/refs/tags/0.18.2.tar.gz"
  sha256 "64717c3b3335b44a252b8e99713e080cbf7944308b96252bc175317b10004f02"
  license "MIT"
  revision 3
  head "https://github.com/dandavison/delta.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e4a5904f5e25b1b653170e507f305fa84f14f51d104cdc194233c49873f8c4bf"
    sha256 cellar: :any,                 arm64_sequoia: "7c27a32de04509f9a25338f7cc4bafb70afd00f7cbea5da8c204a71c0f2a732b"
    sha256 cellar: :any,                 arm64_sonoma:  "a6c8b820d16efadc9177575a7fb3a4a523156d025be6ab605a9309669171e63d"
    sha256 cellar: :any,                 arm64_ventura: "ff3d53184c7906ef335c901fec639c8355f802644d025703b0b39c6b18b0727f"
    sha256 cellar: :any,                 sonoma:        "e17a98613a20338c989370e9d6f456d526b5cfb3d9ba92ad9b6a48b409948ca0"
    sha256 cellar: :any,                 ventura:       "c84810ecf79b524ce48078f5c7356385fd9dd00d79aeb6ce5f907d4e08264061"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06c529b61898673d7b0537378247b4865402459abf6fb0967a5454f895796ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbff34c88d3f5db15c4cb31935f6727e7fc2f682ae3a4e0ccd572685cd5c2fb5"
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
