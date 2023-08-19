class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1568eef8c171318e5252a2b70cf6c73593cdde9771aad628a4e488f959c549e4"
    sha256 cellar: :any,                 arm64_monterey: "bc86ff7a61825bfdce2a6526b1c4f093b925015b237431c55a01c81b5689fff8"
    sha256 cellar: :any,                 arm64_big_sur:  "10dc8abee745d6a0c5050d664c4f215e843eead39c63cd7f8b0b0ea50891a42f"
    sha256 cellar: :any,                 ventura:        "d9aa7c268d33b8b1dd161bed8b5d3d2634bfc29198f84832642cf6c520342d51"
    sha256 cellar: :any,                 monterey:       "ea19bae915f274db6c6cda126037cd5360a562f14e479787c7b29bf0e878fe20"
    sha256 cellar: :any,                 big_sur:        "67f0a92d24fdf4611d3dcaa2a63d47f678f9ff8b4b99a13c47544c713c9654b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b14ff0d2da9a97e00e16d8bc216eea5e81675fa3ce956c4461167ac761d6193"
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
