class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.6.1.tar.gz"
  sha256 "e2eebca8f66ec99ff8582886a10e8dfa1a250329ac02c27855698c8d4a33a3f2"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58f81583dad3866745b8634ce33d8ec0923f2569a8456f1ac97cc39ea8b5fa32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a8333ee530d194671083d7f56d19b5adbc2245f29485a0eda520c25d2468650"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d51d25e029d0bbc208c8638a6ba814a4497cd1775094079d50a943ea13aaa42d"
    sha256 cellar: :any_skip_relocation, monterey:       "f0a0a88c98bd7df9e2eabfd74f4c42e756ed68ac710db169daea39bef858461c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c2a1c9972e0e2e08407edf0420b79e4e6e314c3ff8aee46e1250121cad84587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "345e0dd4dfad4e7dc1c9c1c98cc5c4d66ef6afac5573a355b02e0bb7edb34e8f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "mcfly_prompt_command", shell_output("#{bin}/mcfly init bash")
    assert_match version.to_s, shell_output("#{bin}/mcfly --version")
  end
end
