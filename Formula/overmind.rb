class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.0.9.tar.gz"
  sha256 "bfe771ee32b92d25cb6c5f1525f583aa2bb3703ffcdc188a93507167a003137d"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7e4ff21eb3a5a4d8f498870f27af669765fc9ba92cd1862382086affe81a6036" => :high_sierra
    sha256 "c7df671d29033a384d7987c7ed01dc3a5d4905280bd2f0fc22d2d9bee71f7072" => :sierra
    sha256 "91f58927b9a81b703d1eeb2d6dd4db3802dfc7c8790f567e216db68aba2c0f12" => :el_capitan
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
