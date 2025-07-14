class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https://github.com/KSXGitHub/parallel-disk-usage"
  url "https://github.com/KSXGitHub/parallel-disk-usage/archive/refs/tags/0.13.1.tar.gz"
  sha256 "9f22e20764a434b3cb39a8f92b7e11bea851cca99077e15de165a8a25342cde6"
  license "Apache-2.0"
  head "https://github.com/KSXGitHub/parallel-disk-usage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb45d1cb3873aeef446fe1660474a7b6de315806487b4d6fa17aaec1ded2af6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25d6a8293d85d0b6870b3197c1f457d698cbdaec80d40d8ff55a711978492973"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e235c9e9b7872939e546fb910c1f587d07fdd6e98b4bba89a2c5146269cfa98"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9bd3d9d2a3f9d8851b789c38ce3369c95d92b8aa5c77de66c514671593bbd31"
    sha256 cellar: :any_skip_relocation, ventura:       "4468c0f43d1d2c99a5d812a19be7f69994694643a2363fb62c4e5f53ba3d9997"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24dc2cf8166678deca7f92fdcc4e045dfcb459d56a72bee8de474ab771118a01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e707d710f71fcd370fdf304ba919b8362d815f3fc642b1327041337f9fdb2e0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "cli,cli-completions", *std_cargo_args

    system bin/"pdu-completions", "--name", "pdu", "--shell", "bash", "--output", "pdu.bash"
    system bin/"pdu-completions", "--name", "pdu", "--shell", "fish", "--output", "pdu.fish"
    system bin/"pdu-completions", "--name", "pdu", "--shell", "zsh", "--output", "_pdu"
    bash_completion.install "pdu.bash" => "pdu"
    fish_completion.install "pdu.fish"
    zsh_completion.install "_pdu"

    rm bin/"pdu-completions"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdu --version")

    system bin/"pdu"

    (testpath/"test").write("test")
    system bin/"pdu", testpath/"test"
  end
end
