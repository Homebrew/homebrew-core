class F2 < Formula
  desc "Command-line batch renaming tool"
  homepage "https://github.com/ayoisaiah/f2"
  url "https://github.com/ayoisaiah/f2/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "0785e40b1fd2adb55165f668dc2635d47559fd7534b0f1da33849f155c4e539b"
  license "MIT"
  head "https://github.com/ayoisaiah/f2.git", branch: "master"

  # Upstream may add/remove tags before releasing a version, so we check
  # GitHub releases instead of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60199512555005b0c455a318294ce2461fca14fe73055d6a3d79c557f3e33a55"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60199512555005b0c455a318294ce2461fca14fe73055d6a3d79c557f3e33a55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60199512555005b0c455a318294ce2461fca14fe73055d6a3d79c557f3e33a55"
    sha256 cellar: :any_skip_relocation, sonoma:        "91a8f2cbed065c6ad0e976f8c9a672cd7cd831a65b268423f6eb8348502703af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68b82c40b03fc395853ffaacbe371320c9a7b23c240111c4c78199a1580f0a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb89b5ee0b534374db45f86c91b162cdb2d524a4522ac92e5157343b79e0d3ea"
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
