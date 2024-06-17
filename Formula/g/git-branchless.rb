class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "fa64dc92ec522520a6407ff61241fc1819a3093337b4e3d0f80248ae76938d43"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "94d48275ff7f05494ed9a80084381b367bd56f82e67e265069806987a8411f9d"
    sha256 cellar: :any,                 arm64_ventura:  "6c3c8e9c6246ecbd43f05de74cffc45e76d8ba1f46c5d2b6a014751144f2d4b2"
    sha256 cellar: :any,                 arm64_monterey: "3d1bf86800d60009cfa4e86cdd07bd481493963685c8e189a729a971c7052686"
    sha256 cellar: :any,                 sonoma:         "3b036d955e30b83fde879c735bd9e20bd39880392fd797aea004497a83bfba4b"
    sha256 cellar: :any,                 ventura:        "996464d2800b01b547794dce0d296c10ebb36e4250e2c3eb0b7393b3f384cf22"
    sha256 cellar: :any,                 monterey:       "f92bf814c3ffaea775f71d47941a0b2215d57131431689ab71602dfe4901c258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6b4243dbcb36ee645026ec663cb2472817339f8c7c9cc06f03d287b71f38a60"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    # make sure git can find git-branchless
    ENV.prepend_path "PATH", bin

    system "cargo", "install", *std_cargo_args(path: "git-branchless")

    system "git", "branchless", "install-man-pages", man
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

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
