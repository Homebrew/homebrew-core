class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/refs/tags/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 12

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e348dcdc3d49977fe6647cc92e833f174fde3b6ec3e199c0965639b6e76f868"
    sha256 cellar: :any,                 arm64_sonoma:  "f65c2ae6393964b2aa6ca5932f2c46aa09b66516994b22a6dd9803532f69ff52"
    sha256 cellar: :any,                 arm64_ventura: "66d9169576bcc5e0e50d8cbc4209c7576988a9ad55a38d3b2b9c0bfd66dfc545"
    sha256 cellar: :any,                 sonoma:        "2a6340eeb3800421ce3f529d17ae243c3705c1e0842f0539f8cbcd4d9076bfc4"
    sha256 cellar: :any,                 ventura:       "6dbec136b4be60ee749b0d9cb51c514d978840ad75c8fddf475cba6747c0b9d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd832576f196e9dea9d888881f89d08f9d849b7971fa5b66f1bed7ae942673e1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8" # needs https://github.com/rust-lang/git2-rs/issues/1109 to support libgit2 1.9
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

  # TODO: Add this method to `brew`.
  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
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
      Formula["libgit2@1.8"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"git-series", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
