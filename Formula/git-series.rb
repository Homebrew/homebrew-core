class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "fdac441611169844e14d3493eebede474b613b926744bf2d55f1268107683ed2"
    sha256 cellar: :any,                 big_sur:       "30077bc67f5175001453e18c38ad3de1662adeca57e4408c753baa19274c7568"
    sha256 cellar: :any,                 catalina:      "6739bafe09a3232079693b0cb92378e80421cf395577d047fc3f728efda7436e"
    sha256 cellar: :any,                 mojave:        "13d49cc136dee5bfd78cfbb960af5ee4b5707377aa7e462ff5e98091b28109af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59362bcc4945f3b67fe2fc129ee1a6fba8c97fb9fff230b012c276f7992372f2"
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
