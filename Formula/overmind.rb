class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.1.1.tar.gz"
  sha256 "adfa956df38181cd01380b220590542450c686084d39ba380be384f93f004c95"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9aebf728b23c4c2d5aa08d509c27fba4a097e8145d42e3c0199ef6e1201a412" => :high_sierra
    sha256 "d794ff7073c15ba62e76df8e6ec6e1babfffe2cc3d77d2b98c17f61511a6e861" => :sierra
    sha256 "e3403b71375856c133dede1cf10e98f20a55b52ead26e7602db8bcb482ee2b6b" => :el_capitan
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
