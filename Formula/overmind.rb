class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.0.8.2.tar.gz"
  sha256 "f19cd6bd60238c9c660173ecb772746d9acbf71fa0e467b3a002e758ad32822f"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any
    sha256 "ace11123fd89da9931785431f48e9f4af6d4d99459a259a2b5c7e70601f36304" => :high_sierra
    sha256 "9f4b9fb0ef5a4f815c71294cbedf4306d52acaec9cd3782a396e5afaf36c34f1" => :sierra
    sha256 "900c4ab265035ab1462885526145f57a0c13f982b05a40946a9174fdb6958fe4" => :el_capitan
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
