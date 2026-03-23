class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "0b7992e3ec898e02a5837caeed54512f8fa9a2a78bfc19253c4134343d7240b3"
  license "MIT"
  head "https://github.com/orf/git-workspace.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "23285696507de756063d31a918d4612422e6bc6a09f13f24a96b4d1ae851e9d7"
    sha256 cellar: :any,                 arm64_sequoia: "f770de434800db508f687f766f4783b1d9d5c9df0c1f6cfcd719aaf1122c314e"
    sha256 cellar: :any,                 arm64_sonoma:  "a1cbe64e8c71363b600925c60050528c8c56e144ce2f57aec2914f3a0f28fdf2"
    sha256 cellar: :any,                 sonoma:        "813610ed6838c17768cf836b7d2def4742c4133871e537ba72112a65ecb9ccdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e1014d431a4abd86c219d13c68e5bda12fef8d6ddcb10e5388f368f4b13e773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbf315965767ecb21efbe93e21fc3f8292155b718afd2d1062ef748826d1d422"
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
