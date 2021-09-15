class GitSeries < Formula
  desc "Track changes to a patch series over time"
  homepage "https://github.com/git-series/git-series"
  url "https://github.com/git-series/git-series/archive/0.9.1.tar.gz"
  sha256 "c0362e19d3fa168a7cb0e260fcdecfe070853b163c9f2dfd2ad8213289bc7e5f"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ccf1c1e9a18629fe874987409d79f84da6e171fe802a6918147c3198b0047cce"
    sha256 cellar: :any,                 big_sur:       "2193cb415148a398304ae5cde86bd8f672c62fef1028ad78057d66fa3ca0fd36"
    sha256 cellar: :any,                 catalina:      "e273c21ef68060e010e42bc805bf1a2e5baf9a8e7ecec6338490175857713168"
    sha256 cellar: :any,                 mojave:        "31c32b8df3a5a2c70c54786a0c222ce4fdeccace4cb3a5bf50f3a27d9f46167d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30475b793ee6ea3a5a8291796f01628b735e50b2a796ffe47345a519e730fc7c"
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
