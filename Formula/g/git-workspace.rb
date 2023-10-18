class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "fa89f047bdf5654cc5090cd72fcf0c599cce4182ae0db42bf7eea8c89f387d47"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cbe97d0e1db8c7f897ed10fe11f3598f68cd0dd6d5b41d71738e6c9037aa0c5d"
    sha256 cellar: :any,                 arm64_ventura:  "cf8a85240ef63473754e3b0e35b209a29933b69b869e8496930742372ff30d4b"
    sha256 cellar: :any,                 arm64_monterey: "5ac102a439b3bd585443706aa5007ea6de52bdcb51cd96492e19273bd5b6d3b4"
    sha256 cellar: :any,                 arm64_big_sur:  "d1478ec957a2eb18150917f35dbe4dc808adb5d3844e62cda73cb77cade5113d"
    sha256 cellar: :any,                 sonoma:         "582b89b2da681bba0c83a62d7930627d4a975b3a2974f9b94afc5f6e9469cd69"
    sha256 cellar: :any,                 ventura:        "c21822111578c48341b68fab63d9859326a9e895a0c588716ab1da86fb21dc44"
    sha256 cellar: :any,                 monterey:       "d45cc54c40cd65837b0d80f8807743cbd65397d074281a30d5f5cba12162f62a"
    sha256 cellar: :any,                 big_sur:        "b42260ce3fd93089ae0fa86bc2353de252cfc0a746fa86d2aaf857d5d80bbf4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b156efac1e9c4f361210d9c4213c4e793e428a22d0d5dc65d9760be0c1b5096"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

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
