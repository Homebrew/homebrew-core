class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.1.0.tar.gz"
  sha256 "6b220bd07cb33925a4af64a3ba66b3d0f3c0b93602f61b6a558593f8b474f705"
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
