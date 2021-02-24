class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.15.0.tar.gz"
  sha256 "d2551b1ae3c8ec61e0d161e8a75efb16fea1e0716eed0095f23bcf5bfbc8d758"
  license "MIT"
  head "https://github.com/profclems/glab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9f808145bcdabf7e5da3a206ca5a99c71f16a2cfbdd034174514045e5d1c28b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "237fed49948c5ab0556d233513557a7d3b1fae5f58150d4959fbb1f9bfd5f60b"
    sha256 cellar: :any_skip_relocation, catalina:      "535b1c9a003e145e4aa336ff697bd54d3a884010d8dea8f21790e887bb148c64"
    sha256 cellar: :any_skip_relocation, mojave:        "783d63f27777304dac72bd6f2667dddf32dabd91c590cf430a56031f84cda194"
  end

  depends_on "go" => :build

  def install
    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    output = Utils.safe_popen_read({ "SHELL" => "bash" }, bin/"glab", "completion", "bash")
    (bash_completion/"glab").write output
    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, bin/"glab", "completion", "zsh")
    (zsh_completion/"_glab").write output
    output = Utils.safe_popen_read({ "SHELL" => "fish" }, bin/"glab", "completion", "fish")
    (fish_completion/"glab.fish").write output
  end

  test do
    system "git", "clone", "https://gitlab.com/profclems/test.git"
    cd "test" do
      assert_match "Clement Sam", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
