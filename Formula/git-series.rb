class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  revision 2

  bottle do
    cellar :any
    sha256 "2073a7838f6ba7f715bc056a1855e71ce4e2d800f6f3ecaaa455bd9d38372eab" => :catalina
    sha256 "bbad06cbdc7e4d275aa65b8ca0c7148583a35181200a3eefc4b48f691e195010" => :mojave
    sha256 "3a41df7702c89ca5d9cce8aaf667adb8aea8ac49e63962e73cded92ea765338f" => :high_sierra
    sha256 "76bc22f517e888f1090927a582ccbcf5f09493cc127cd00289008342ffb5a08a" => :sierra
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
