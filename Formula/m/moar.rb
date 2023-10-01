class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "519a6ebe95b7a325966acfc13fb65c258609940042bf02f086ef2a5f4e59cbb6"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f2f41efb511137db8c90d1eed8758c8659a05aa392cbdd9ee2325e1b34c67f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f2f41efb511137db8c90d1eed8758c8659a05aa392cbdd9ee2325e1b34c67f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f2f41efb511137db8c90d1eed8758c8659a05aa392cbdd9ee2325e1b34c67f7"
    sha256 cellar: :any_skip_relocation, ventura:        "b4c61c556af5792882559d2e0dae5c2bd55e857f778b0532df824754e5fac78e"
    sha256 cellar: :any_skip_relocation, monterey:       "b4c61c556af5792882559d2e0dae5c2bd55e857f778b0532df824754e5fac78e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4c61c556af5792882559d2e0dae5c2bd55e857f778b0532df824754e5fac78e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b9bad8587c2a3ab21c666dd2754ee717386d72447c908e0b90c6d60ebb3e0a0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
