class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "b962a879594d916c6b5bd5402ef323cb8a7e0d2112ea4d46998409e485ed48d0"
  license "MIT"
  head "https://github.com/orf/git-workspace.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6ac5f815523a23ed6bd0612293d2221f87d929d94d7789cc3da6d504e47fbcf"
    sha256 cellar: :any,                 arm64_sequoia: "6bf616927a82d2d116caf1650507e88be477c9d1d8548c4ebcae2adea6e294ec"
    sha256 cellar: :any,                 arm64_sonoma:  "bbecaf7262599228c1c15472b78d72be552516800ac1a09d89dff83400ba588b"
    sha256 cellar: :any,                 sonoma:        "8212ca5c8a97fa76305697d8a107dc0c173e07473fa562d6dc810cb570689da9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9fd69840b3ef28bb3aa567819a5e81f06e5a49364a43ec03ceef8b73dd5d54a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d0bcdf8d607acdee86c6dbf299e84d6991ad6439b372ea2490eb1509f92c85"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"git-workspace", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
