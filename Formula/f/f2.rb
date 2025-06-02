class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https://github.com/ayoisaiah/f2"
  url "https://github.com/ayoisaiah/f2/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "bd7c6779f456e1ee7b4be4d4b7b24cca90dbbc2fa52efa8eb7ca012480e27830"
  license "MIT"
  head "https://github.com/ayoisaiah/f2.git", branch: "master"

  # Upstream may add/remove tags before releasing a version, so we check
  # GitHub releases instead of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b0c7f878c7e6c857c90354ff2a5f4d963869c8f06cf7fe484d73ad0ee5061ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b0c7f878c7e6c857c90354ff2a5f4d963869c8f06cf7fe484d73ad0ee5061ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b0c7f878c7e6c857c90354ff2a5f4d963869c8f06cf7fe484d73ad0ee5061ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "241c34916fffe05df32bdee8c89a4229c0451f3de06a79b6d6481d216f442fa8"
    sha256 cellar: :any_skip_relocation, ventura:       "241c34916fffe05df32bdee8c89a4229c0451f3de06a79b6d6481d216f442fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ee3b068caa6c3c0c9682d3d8fc60ea34deb10413cd6836bdb129c3a56d25d2e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/f2"

    bash_completion.install "scripts/completions/f2.bash" => "f2"
    fish_completion.install "scripts/completions/f2.fish"
    zsh_completion.install "scripts/completions/f2.zsh" => "_f2"
  end

  test do
    touch "test1-foo.foo"
    touch "test2-foo.foo"
    system bin/"f2", "-s", "-f", ".foo", "-r", ".bar", "-x"
    assert_path_exists testpath/"test1-foo.bar"
    assert_path_exists testpath/"test2-foo.bar"
    refute_path_exists testpath/"test1-foo.foo"
    refute_path_exists testpath/"test2-foo.foo"
  end
end
