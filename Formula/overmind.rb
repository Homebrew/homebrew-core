class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.0.5.tar.gz"
  sha256 "d23caf176de2a231d4939d43e1f8642bcc6d833a1778d029003fd96e8b50609d"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15428b47b9e686d1cefc38c1e73c7690c37a949ba0ecd7787b10fbf0ef46cc08" => :sierra
    sha256 "bc7ae8f1cc5c8263e4096f55448003c508ba0f664002ff7d41a274d8013ed11a" => :el_capitan
    sha256 "78a2b08b1064f552836cdd88e75bd4f20642c8683873b91cc32aeb987534c802" => :yosemite
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
