class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8e62e399cbba54341ee1bc7102862926e8c12d08b852d24fab6b8e45e253cdcb"
    sha256 cellar: :any,                 arm64_big_sur:  "e394b22f7dad47f5fad8551ac8ec850581dfb30014a476a6adbdadb170d89d98"
    sha256 cellar: :any,                 monterey:       "85dc9d45f805faf62c56845d34dbbcba950ff1a894399b8ada665349c58141db"
    sha256 cellar: :any,                 big_sur:        "e5e96220146d2666fffa5bfbf61c56a03213227583e09f7f82780a5113233f1e"
    sha256 cellar: :any,                 catalina:       "628b077ef0b4a60f22637802a65369eeea31d778af2ce926f548f8b4e1aefcd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd1be3900aa1bf6e374228cb0f8bf0bd37e34592bf077fe412109e28c9ea8d0"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    # TODO: In the next version after 0.9.1, update this command as follows:
    # system "cargo", "install", *std_cargo_args
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "git-series.1"
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
  end
end
