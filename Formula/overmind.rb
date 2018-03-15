class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.1.1.tar.gz"
  sha256 "adfa956df38181cd01380b220590542450c686084d39ba380be384f93f004c95"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b837992c446a33e99493c4cc1ef7c9479e75bc540f24e04e773c999ceb7d26e1" => :high_sierra
    sha256 "4954106239383d8f587060b177ddfb76b8d2d0008bcfd336a93bbe4963419595" => :sierra
    sha256 "09c011b9aa59be593a7fe27274f126ac7f5ad58f058a5dd54ef835ab7d596909" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/DarthSim/overmind").install buildpath.children
    system "go", "build", "-o", "#{bin}/overmind", "-v", "github.com/DarthSim/overmind"
  end

  test do
    expected_message = "overmind: open ./Procfile: no such file or directory"
    assert_match expected_message, shell_output("#{bin}/overmind start 2>&1", 1)
    (testpath/"Procfile").write("test: echo 'test message'")
    expected_message = "inappropriate ioctl for device"
    assert_match expected_message, shell_output("#{bin}/overmind start")
  end
end
