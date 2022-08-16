class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "776b0da4754574da103f9e40a2ecfd7c681c2f65f975982e5a205ad0a1934321"
    sha256 cellar: :any,                 arm64_big_sur:  "bf45b2ebdb40c6c2e38cb2b3ab15b5a17ac250c6f0a6ad6930b8a8a4561716f3"
    sha256 cellar: :any,                 monterey:       "19b97cd74d2bf96feb0c7852391aca459f586c7775e3255aba7573ecde2bb423"
    sha256 cellar: :any,                 big_sur:        "fedb5ea7626a89ace95948ed1b0f12da3ff070cbf1850807093292df777513e2"
    sha256 cellar: :any,                 catalina:       "e169a38cff276920853242b4ce1b31ee8493b9abb6a0a34e79a153c64c95cb5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e584bfcb9fdfbd4385b6865faf9123342f9fcceef3bb14ad9ee213243b69de1"
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
