class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a238e7eea725642aafeaeb5f90d66a97f4e5b2caa681d51aaa47abe4d2ec371b"
    sha256 cellar: :any,                 arm64_big_sur:  "d75d535676dda5c4289d8547cd6959f02aa6d5fa47364ebb561fe8a858683c95"
    sha256 cellar: :any,                 monterey:       "83049175c7154cda07fcb03ec3d2950412e49be5a50180aa51e67d2721815fe8"
    sha256 cellar: :any,                 big_sur:        "40f73d58772d698175f87acceaf11f97720e3248f2cf7182bae19889899ed61d"
    sha256 cellar: :any,                 catalina:       "944e5375b6975f35b298b03f8ccdd9d530a9991593c6374aa3d93a69a8a0baac"
    sha256 cellar: :any,                 mojave:         "9edf9487a836d8ddb3b822f1a14931d2e2413edd9d3df29b389259a684681190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52c715891324bf3e223e02ca509db21d171fcddc8e741479ad18164f385c3d4f"
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
