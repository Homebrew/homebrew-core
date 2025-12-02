class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  license "MIT"
  head "https://github.com/orf/git-workspace.git", branch: "master"

  stable do
    url "https://github.com/orf/git-workspace/archive/refs/tags/v1.9.0.tar.gz"
    sha256 "d5e2a5a0a568c46b408f82f981ea3672066d4496755fc14837e553e451c69f2d"

    # Add command to generate shell completions: https://github.com/orf/git-workspace/pull/422
    patch do
      url "https://github.com/orf/git-workspace/commit/64a45045aa8297cdbaf081b76e5af8531f7c4364.patch?full_index=1"
      sha256 "759bbc4ca0ee122758c9eeb0e4ea19bea09d9d5a2ad10c1f26680a441750f0f8"
    end
    patch do
      url "https://github.com/orf/git-workspace/commit/1a1e35a99a783e02c563b531e5eb370cd7e80c9f.patch?full_index=1"
      sha256 "f6fd8bd2e7fe5ec188883e7d7f19328a48d8c68a39733ff3de4a3639a1addb88"
    end
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "ff841dbfff6684c2d11c1e92d6ffbf4397d87c59cd1f04527b372c6df7ccdb37"
    sha256 cellar: :any,                 arm64_sequoia: "5ef41bffe5e1f4d2a3f3874db4cca0ec3924f7667c50f31834758581bf082132"
    sha256 cellar: :any,                 arm64_sonoma:  "c11ad5b5dee8c00c0d0421c2ab7e356160d70518911c760fd5b43187c1bc9eb6"
    sha256 cellar: :any,                 arm64_ventura: "f1e37cf9916870cbe619862abab8b9b6a5c0b0c63b8e69f6ca35768bb3ce8109"
    sha256 cellar: :any,                 sonoma:        "8fb3fbb9ffd67fb1e903acc3077c0d9c077407a6632eb073ada084e5d1b207e7"
    sha256 cellar: :any,                 ventura:       "acf69daeb6c6a0ce1e01c9fa07c2887e2ea113ea322808fcbab5a95357963037"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf5e71a37db57042916353b7f26eccfa3d67558d4a76bf0df905cc9f54562869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8188c9fbc81960e1c50aab9c036a6209ac0712350150c75399752fb9326d9ca"
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
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
