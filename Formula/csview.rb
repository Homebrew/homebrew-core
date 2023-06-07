class Csview < Formula
  desc "High performance csv viewer for cli"
  homepage "https://github.com/wfxr/csview"
  url "https://github.com/wfxr/csview/archive/v1.2.2.tar.gz"
  sha256 "c8c4d1207b225e4257f301af6333d28cfee611781cfa51bf8227b742b043105a"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/wfxr/csview.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e42c9e597ae8be86fb856bb117a9342495b3813f06b930efb14333ceb54c44d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bcb6b524bfbe7d4cee5a4ed47eb9fbe6e460165b8a3b1e5b47391e3ccea588c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "714f0dcb10d7d0a00f0c234f999eb1b18521f1f6443a4f781bf192b5603f8100"
    sha256 cellar: :any_skip_relocation, ventura:        "6f62c3017653188b898c1aea5376ffe1ccbf0041aad78cf85c2b5266d0841d54"
    sha256 cellar: :any_skip_relocation, monterey:       "165a69b5e284288f82e0e70e1a33755c3545a6fa19ef5e2511d21d90fbb22796"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a0a21831088d78cb6d28567fda931d01a242e5b77eefb21cdf420a4f8db351c"
    sha256 cellar: :any_skip_relocation, catalina:       "bda29a8d29c3a9263f35151c347b9791b45eb8f40e9709f76d623472c015a6d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47d0c394c85f711c1c98dbbe724f7d0e1820725fffc8a716b9f0fb73c87d34d3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    zsh_completion.install  "completions/zsh/_csview"
    bash_completion.install "completions/bash/csview.bash"
    fish_completion.install "completions/fish/csview.fish"
  end

  test do
    (testpath/"test.csv").write("a,b,c\n1,2,3")
    assert_equal <<~EOS, shell_output("#{bin}/csview #{testpath}/test.csv")
      ┌───┬───┬───┐
      │ a │ b │ c │
      ├───┼───┼───┤
      │ 1 │ 2 │ 3 │
      └───┴───┴───┘
    EOS
  end
end
