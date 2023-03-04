class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "b9dcc7ad2c88f63a12af4caafee05b433391a6607252330335d37676686b24f3"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "6ed27ceed65ac2655ef93ce0b44475488d81c384ca499ace07db75767d9c2eb7"
    sha256 cellar: :any,                 arm64_monterey: "7546558a4f5f4eb7d55061b3fd9902ebbd54a42b03a444c76407f8c17f2d9beb"
    sha256 cellar: :any,                 arm64_big_sur:  "f9ed91ff0380b79678fbfeed46472368e9df93737a99d28c0af9e224d11b0bcb"
    sha256 cellar: :any,                 ventura:        "c8da403ce1d1c5891ab96c763a3ba7374256c551906ddf41cf1917207d8bc619"
    sha256 cellar: :any,                 monterey:       "8415477fec337fe03a1d36f4795b0bce527e6ff167889833317e2a603ca455e5"
    sha256 cellar: :any,                 big_sur:        "56adb55360c0f22508212022a0d2ee33ae94ff79d99a7300ccbd38d62e8a6007"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af4daa92e3617d5886e3148962a1a2afc4373ebdca036231eddfc3e8bfcc0e7f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
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
