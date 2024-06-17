class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "fb66b03f4068950ba2fac73b445a964b2b941137f9b31f5db9f4fba1a73d3d4d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cdc40292261367e43efac7c65c58247c660b86cb6595c1e1fbe87b14b8545fb9"
    sha256 cellar: :any,                 arm64_ventura:  "e8ed90e4eb662292f10163db48f4ef25aa70bc3a4b82a03b96b89ccd486f5013"
    sha256 cellar: :any,                 arm64_monterey: "66fd4cd3620dd1df2e6a9bf651564d259f7c23905e8840dc234aabf413c1a5c5"
    sha256 cellar: :any,                 sonoma:         "a563a1d8c3a123f233385e37fbe9069473e0647abcf00dd72ea82a9981f1fd2f"
    sha256 cellar: :any,                 ventura:        "55f0f1a536630d5c7e77d0ceb992a036d5c256c8585ef1181a9b5639d82256fe"
    sha256 cellar: :any,                 monterey:       "3965dc4c9d752cea518b063a113fdd16a41f74f93f4a413f7e8758567121d9f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba758eb783b257fb2bf928c55ef65877cb0d222687ded4913d3ec85b1afe759b"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["GIT_WORKSPACE"] = Pathname.pwd
    ENV["GITHUB_TOKEN"] = "foo"
    system "#{bin}/git-workspace", "add", "github", "foo"
    assert_match "provider = \"github\"", File.read("workspace.toml")
    output = shell_output("#{bin}/git-workspace update 2>&1", 1)
    assert_match "Error fetching repositories from Github user/org foo", output

    linkage_with_libgit2 = (bin/"git-workspace").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
