class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.2.1.tar.gz"
  sha256 "114a51b45fe02205d28db1fb1b6e23e501c3935f7d3b8862e7db70c41153542f"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "50ae747635c04c6a1e91d821b22c1d4cb62151a5c7db0f01b98a43bfa61e49e8" => :high_sierra
    sha256 "8dc04b334f1a34add501dc33f68299ae1d366292b787574855bc1ab4ba378f7a" => :sierra
    sha256 "4937f5ec45d2a0f63360aae77ccad1b25276f71ae2edcb7de821d031fb29d81e" => :el_capitan
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
