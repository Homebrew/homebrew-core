class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "547ccd48bedab03f0439920be12c37cb02f837e27cba3a0fa5166dfc34199274"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a664c2005258367b604d7fb31a80f8f9dfaf5ccd2b9d32f8226868aeadcdba37"
    sha256 cellar: :any,                 arm64_sonoma:  "6efe100bc02d6fe50e9a4834522d3f2e7f13d5778142a6f56a524dccf70067c3"
    sha256 cellar: :any,                 arm64_ventura: "158b62a573be88e82afc5f05426ae29e2d5c4bb9e72a55438905238ea9aaf145"
    sha256 cellar: :any,                 sonoma:        "9d7da5c7c03137653583c077700e0b7bfc05abcfcf9be1c9e01f6bbd30d2d63a"
    sha256 cellar: :any,                 ventura:       "05db764547caa9d0bc19b2e2f843fad408ca6d03b9d326f02bceffc2288be8d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "084cfd8dd58e7b636cb63a7d5ece84846e596277a76bda14ed6b7736ef765315"
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
    system bin/"git-workspace", "add", "github", "foo"
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
