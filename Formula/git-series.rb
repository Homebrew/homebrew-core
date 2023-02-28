class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 7

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "76107d37585c43d3c7ea8f69971b1a2485a221e3ce0c87b2b1860ff097e76f17"
    sha256 cellar: :any,                 arm64_monterey: "908fc5596af1e413b3f9aa6a50f50adda016ddb025f2eeaf4b532072e0364d95"
    sha256 cellar: :any,                 arm64_big_sur:  "24739f0dd29b00b52ef26a38658662184801d30b7dc8c33e9e46e5e1ec351aeb"
    sha256 cellar: :any,                 ventura:        "9afeaf659a5b2b490e829c9d1cd75dc26458af33402e63738ecda3998bbe4008"
    sha256 cellar: :any,                 monterey:       "386da3ab9a088239de9d642c164768504517293fff3d0189783e3ab8aad8f791"
    sha256 cellar: :any,                 big_sur:        "caf6563a0c6f3ff85c59c97464b05e2e27509d87ed344f1693d68d903b297770"
    sha256 cellar: :any,                 catalina:       "3df33788f9498b11b518b7555b4ad7f3d4fd188777483eab9ab2d1aa3ce05e0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d5130d7d0265432d2f1dc775f20bbb09d6ff7ce5c98e9b839972c94308c2332"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@1.1"].opt_lib/shared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"git-series", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
