class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/refs/tags/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bbf088fcb4b5ef9f6a32dec074b9aa98b3e53dc0b990361b6497a504aad42787"
    sha256 cellar: :any,                 arm64_sonoma:  "4d0310b6b5dce374dbc590d9c16e65b2a7b20b70ed2c568213a940799bcb623d"
    sha256 cellar: :any,                 arm64_ventura: "56c214679e80ce1a0ef58072f3970717c8a0007ec1acd56edd386b1a99c13cc4"
    sha256 cellar: :any,                 sonoma:        "b6945d9ad85eb435c21e90c3197fe88e200797c1fb4da7e72ec8a15a33df91b1"
    sha256 cellar: :any,                 ventura:       "3fb478881046f6409ac052ea2eca2ca32596c00872581d247fff65c220fa365e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d2ab0f405903c2fbc6d3b4c6b8d59d25253b508a09fb37e7aa2f72ffd9905f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4b86f524114ae9404d558a105686e25fef4859460a73cd4042f43b89b67e896"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    # TODO: In the next version after 0.9.1, update this command as follows:
    # system "cargo", "install", *std_cargo_args
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "git-series.1"
  end

  test do
    require "utils/linkage"

    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS

    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "-m", "Initial commit"
    (testpath/"test").append_lines "bar"
    system "git", "commit", "-m", "Second commit", "test"
    system bin/"git-series", "start", "feature"
    system "git", "checkout", "HEAD~1"
    system bin/"git-series", "base", "HEAD"
    system bin/"git-series", "commit", "-a", "-m", "new feature v1"

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert Utils.binary_linked_to_library?(bin/"git-series", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
