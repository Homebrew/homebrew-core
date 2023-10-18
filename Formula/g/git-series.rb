class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b4cb77bc3e8a626bc8a490b3f43e079fe7c474ad8b0df429af8f6bc72d8507da"
    sha256 cellar: :any,                 arm64_ventura:  "09bac8a166e42326111fd8473ae3c7a9ff6291989d8a275856773ca85482ec7a"
    sha256 cellar: :any,                 arm64_monterey: "b864619ca53b4b446f46d18f871fc10559aa566e54818ffd982c4b4aa26f9cc8"
    sha256 cellar: :any,                 arm64_big_sur:  "ac2992338ed769e8228cb1a78aa76b0d00e9ba48d81f0d3ae8c20ce86b4a0ea9"
    sha256 cellar: :any,                 sonoma:         "ff61b72a799758cec2cfd9a656a88589b5f319cafce6ccff27900695371a48b5"
    sha256 cellar: :any,                 ventura:        "e2eb3577da8e480f59a8288f3ffb1135360772651b538413bdbb20f7ce7831ae"
    sha256 cellar: :any,                 monterey:       "8fc34ddc950682131191a0b1c7e5dabfb6a66b4d50e115cf1d73313999e52e90"
    sha256 cellar: :any,                 big_sur:        "3874b2b34b9e86b75a71862e4d029117ecb46ce56fa359bfd7d033cbcd6c10d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f574fa247ed592c41e75a5ebb4b0946442de12a6c23be915ac0915f89e889797"
  end

  depends_on "pkg-config" => :build
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
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@3"].opt_lib/shared_library("libcrypto")) if OS.mac?

    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"git-series", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
