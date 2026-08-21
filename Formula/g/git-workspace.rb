class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "e2cf64219d6235a587448bef093224ceccc144697e2e3ebad2380236f2373404"
  license "MIT"
  head "https://github.com/orf/git-workspace.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "287d4176521300d2316c3d8269415953438589b4f4f182e51f487944a7975e8f"
    sha256 cellar: :any, arm64_sequoia: "693010f83b8e50c1a21b087b869270ea226eb6eb56008c8f5ef046376390bd54"
    sha256 cellar: :any, arm64_sonoma:  "29485192ce75698d704ab8aeaf8c2292a88e3e84ac48c2a6e3a9a0695b577b24"
    sha256 cellar: :any, sonoma:        "d64d2fa80bca96b4921bf2dcb6ddb60997ce4da31db997e40ca58e8cedaf1800"
    sha256 cellar: :any, arm64_linux:   "26cddc8156b0ccdbd1930a02e6fb35fee795d8cc8a8846e3c607b91b2870fab4"
    sha256 cellar: :any, x86_64_linux:  "87918f692138b00ac615e3892f7ddbe7b9298ff300a3a0c247d8791c138c9c23"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    ENV["GIT_WORKSPACE"] = buildpath
    generate_completions_from_executable(bin/"git-workspace", "completion")
  end

  test do
    require "utils/linkage"

    ENV["GIT_WORKSPACE"] = Pathname.pwd
    ENV["GITHUB_TOKEN"] = "foo"
    system bin/"git-workspace", "add", "github", "foo"
    assert_match 'provider = "github"', File.read("workspace.toml")
    output = shell_output("#{bin}/git-workspace update 2>&1", 1)
    assert_match "Error fetching repositories from Github user/org foo", output

    linked_libraries = [
      formula_opt_lib("libgit2")/shared_library("libgit2"),
    ]
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"git-workspace", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
