class Mcfly < Formula
  desc "Fly through your shell history"
  homepage "https://github.com/cantino/mcfly"
  url "https://github.com/cantino/mcfly/archive/v0.8.1.tar.gz"
  sha256 "727fc98b7291cc5b79c90a48d2e4460bc71550f221be8d2dad2377580f9b2d72"
  license "MIT"
  head "https://github.com/cantino/mcfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f67220a70aae9b0456e64905e9abf6d9491c2faec821ce74fbe11306e6b5ad95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bfdd45848293e58bf64db6e6c33630314049c4bbff7099a9ded4162f21cbb53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4baac51490a81cfa298c10d88c2f8352f8ce461bdd9aebfdd0fcfbc20cc6b173"
    sha256 cellar: :any_skip_relocation, ventura:        "c0a3b4b449fdfaf0dae1b40559ca7c2dcce8b42e3a53a685ae34a189db5e7b05"
    sha256 cellar: :any_skip_relocation, monterey:       "166c303a51dd6bfd7df625a34555f92e1b28d5971fbb02debbd0df877027ded5"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b38d58778c3515f4122d9d28063a97ab43261dfb347dac7bc504dede6349ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f17b293954a7e6a9666b6aef067a284cb365e64d1bb6ee47d7f8d939715833dc"
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
