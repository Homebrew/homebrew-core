class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "42413850a298f8d82737b7b1370b8c15be55927368d109eba7a599e498a441c1"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a2c447c385aa68c56fcd263065f94d84e977902ec91ea4b6053a1cb6174f8859"
    sha256 cellar: :any,                 arm64_monterey: "dc25a621de6765ec2e7c1872545b479907e42dc156079da7e749074b83b86a1f"
    sha256 cellar: :any,                 arm64_big_sur:  "e04222703ec04e7b3f79324e56a998cbaf3c97be0601e75d66979511907abc35"
    sha256 cellar: :any,                 ventura:        "ce6d962eff2644c843150d2f95fae0860c97e0b2c653230c05713728086d0b98"
    sha256 cellar: :any,                 monterey:       "1640cbf2c6f1508a260fc52054d0625893d506b5210506749b6da99194914106"
    sha256 cellar: :any,                 big_sur:        "e5be9943b8cc31aa771c59ecfc673129be0f7c2423d3dc3a6044a0d2cd303d90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e340c952285657d726083286f4028714877302d4e565d840e0ae3b04ab8445df"
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
