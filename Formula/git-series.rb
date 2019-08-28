class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"

  bottle do
    rebuild 1
    sha256 "530a8604bce82c2b2ea08123873fc3ac29b0f1c4805a59aa876ff8a04668b057" => :mojave
    sha256 "f22eb16a878279e6613c26c92348d48e5c3aa9916bb9598589857d9bcc7596da" => :high_sierra
    sha256 "602d435ffa40726db60f3bd69bd7d1e6eacc51f587daeb4afb022e3b147068a3" => :sierra
    sha256 "3365e4bad3de55810eb4b8fa8788c19b7d56f2a28bc76b0a03601c1d9a37cd0c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "libssh2"
  depends_on "openssl"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

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
