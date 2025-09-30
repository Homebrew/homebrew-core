class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https://github.com/ayoisaiah/f2"
  url "https://github.com/ayoisaiah/f2/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "69e60baeb8e15644088713d7b2fb1e7d23131a92ef5fa61ed4c2c18160078ff1"
  license "MIT"
  head "https://github.com/ayoisaiah/f2.git", branch: "master"

  # Upstream may add/remove tags before releasing a version, so we check
  # GitHub releases instead of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20b9ac62100ec247caee037f1bef031b4b9794cedf6776807c0cb603a41dc105"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20b9ac62100ec247caee037f1bef031b4b9794cedf6776807c0cb603a41dc105"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20b9ac62100ec247caee037f1bef031b4b9794cedf6776807c0cb603a41dc105"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cf1ad63cbd2dbec21a018c24c1e1a911db504187ec70214214b55cf73c59f2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4784160f2ac8eeba3b140a355891b208463117ad21bf77ced6f3120c8c10c4df"
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
