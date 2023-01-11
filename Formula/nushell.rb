class Nushell < Formula
  desc "Modern shell for the GitHub era"
  homepage "https://www.nushell.sh"
  url "https://github.com/nushell/nushell/archive/0.74.0.tar.gz"
  sha256 "7483fabd62e121d93f4a07c154d2f77d0a1f319b6aba996d94d86b157a206078"
  license "MIT"
  head "https://github.com/nushell/nushell.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "173c0ce85f333b60cecfbcf49f1d1673cc9cae9bfff176ce68b9b73ce9d22cf9"
    sha256 cellar: :any,                 arm64_monterey: "891608d7014b4841a0beeae82f8515fb04b3c25f07d1495bd8d7ddac44942a25"
    sha256 cellar: :any,                 arm64_big_sur:  "5b03176842a8ea1ebd5bb03e1da5ede5645babc3c001bb71591f7680d1882770"
    sha256 cellar: :any,                 ventura:        "e3f1ada87ea4e1f2fec690e471ef395b83c26b62080184742a8d57b9169d765b"
    sha256 cellar: :any,                 monterey:       "21480c373d42e117c5e8e1df482f4ace4978e2e54fa4e7b1961528c54ab8ee1c"
    sha256 cellar: :any,                 big_sur:        "cad1863ed55566ff661caafcc363e23a7be1d0438bcc288fb8f6191574fadc49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54ae461d997f62d73d23b96b4391054dc4947bfeab1a14e8fe6ca3ff46ab53f1"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", "--features", "extra", *std_cargo_args

    buildpath.glob("crates/nu_plugin_*").each do |plugindir|
      next unless (plugindir/"Cargo.toml").exist?

      system "cargo", "install", *std_cargo_args(path: plugindir)
    end
  end

  test do
    assert_match "homebrew_test",
      pipe_output("#{bin}/nu -c '{ foo: 1, bar: homebrew_test} | get bar'", nil)
  end
end
