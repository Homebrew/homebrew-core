class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r25.tar.gz"
  sha256 "a4590c046ac2c2b338de64aad5b6bf76cbad11b5503d141677536ecef7019119"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "013b12e45ce6d3a25d952adef77f8c3ef8f8a7ff7464accb2c42b79ab509c004"
    sha256 cellar: :any_skip_relocation, big_sur:       "0e742ca0c46012ce472565999d8d6d2725c87ec6b59ef4007e16cadfdacc0670"
    sha256 cellar: :any_skip_relocation, catalina:      "30c756ad4361ae806e7f2c5c17cdf96fde5c482aedac1cb1d0d2cc60b7304492"
    sha256 cellar: :any_skip_relocation, mojave:        "388215d3cff682c04d6a9d7e4ac2e66170702fd4622b9ea1a061141b085a9425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "502a37242a51501083104f019c551bfa6135d791badcedf6752100729de9ca4d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.gVersion=#{version}"
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
