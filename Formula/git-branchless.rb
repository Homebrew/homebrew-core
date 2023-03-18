class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "13a7441be5c002b5a645dd9ad359dad5bdd46950b51b49e3cddccd9041deb5f5"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3b15a0014d1d7e2fdc892ab5d38965a8a591a5149d3b54c877043c5359014250"
    sha256 cellar: :any,                 arm64_monterey: "c10870c88cae06ac4f753c8f6a27002fd71d8d8cfb24d6d2589b394ce2feb9f1"
    sha256 cellar: :any,                 arm64_big_sur:  "5c6b344e5fd806572f1d731a8527f081bf7797afefe8db461697b7ba1b0f5363"
    sha256 cellar: :any,                 ventura:        "db52bea912490c4a239744c162bb8cbad57c9444673435e8212b1bfda02e1399"
    sha256 cellar: :any,                 monterey:       "53155b19c1dc1a97825668daa2da320aa1d1f552efbd1c8bdcc7f0c0ad862803"
    sha256 cellar: :any,                 big_sur:        "56751c64ac4a7d19c4bc9d9bc703e7d4d39c4decab281a8f6e49384914fd868f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d88f797d0eb03f94e7c44ea10486f1b30479365cb7df44a738066c8f9e7d5e7c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.5"

  def install
    system "cargo", "install", *std_cargo_args(path: "git-branchless")
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"

    system "git", "branchless", "init"
    assert_match "Initial Commit", shell_output("git sl").strip

    linkage_with_libgit2 = (bin/"git-branchless").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.5"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
