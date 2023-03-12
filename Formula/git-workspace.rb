class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "42413850a298f8d82737b7b1370b8c15be55927368d109eba7a599e498a441c1"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e625c6e986197e317d036f6edb60a57bc6d091fa16279d801a43ade85fad2c36"
    sha256 cellar: :any,                 arm64_monterey: "18e680082435e5dc6302e084b600b5bbb6bc3671704db4ee095b5e1c7937e924"
    sha256 cellar: :any,                 arm64_big_sur:  "c0c46de4cdbff22a5a7f2699e03105ad8cfdcf1f650ce937a53d2ff5e5c57857"
    sha256 cellar: :any,                 ventura:        "be2690acf2355877c7155fe6c5b548d8d10bef91c9947290a6c4b85fdf246f92"
    sha256 cellar: :any,                 monterey:       "c0985177ea20a45a8d1893b18e9c82983f65b8129cd0bd84cec8bf694d06cc3f"
    sha256 cellar: :any,                 big_sur:        "3a9964159fe6eaeccd2cb3d6b529c77d8237f97ce79a38671a21a23f39b474e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ad471abc371d219b650d57dbcaf070261a887855ddf04c84d6d3f44692bd890"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.5"

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

      File.realpath(dll) == (Formula["libgit2@1.5"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
