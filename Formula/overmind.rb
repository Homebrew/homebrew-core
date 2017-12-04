class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.0.9.tar.gz"
  sha256 "bfe771ee32b92d25cb6c5f1525f583aa2bb3703ffcdc188a93507167a003137d"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72aadee002dc2d69308b6e3be2def81528e302a5b88eef740b15985f628f0ea5" => :high_sierra
    sha256 "e5139d1dbff776b4b4678c5ee15552eb6301e76257c01be14fdf48eaf8585d20" => :sierra
    sha256 "414fe99bc0e3472234aec9aeaf9bc6929b19b7e3e7ca46cf5da5f882a9503cf5" => :el_capitan
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
