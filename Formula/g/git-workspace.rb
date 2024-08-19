class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "8064f7bae8cfd049b27faaaa4536e61e578d2789970ca4ed8cec82af6dd962b8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5e31cf866fa3e787ddd99792c2a035448193fe1d16e527a56f31bf1825056cf8"
    sha256 cellar: :any,                 arm64_ventura:  "4e09723e04f3e1e933b52d6f6cdea3a92973acb76c668118978449d7561fc437"
    sha256 cellar: :any,                 arm64_monterey: "d2602a65865a4566cf60a9f2546e366298c733d57593e9127e6fcf6a349e37ab"
    sha256 cellar: :any,                 sonoma:         "675ee40c362d2dc544cd87caa77ac83261bbede2c2cef9b27fde0420ba1dcf48"
    sha256 cellar: :any,                 ventura:        "11a0770afb555a3c457281605022ede5db72deb6c96ecfe80b2e20616e746a62"
    sha256 cellar: :any,                 monterey:       "18c81743d8cf59686d331abc3023d05a05d2996cd5a8bd26fd5cbe7a4fb5d31b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9517346daa08e4593455d81ad4750eeb25901cf4e9cc7b9e4f923f2de7846b5e"
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
