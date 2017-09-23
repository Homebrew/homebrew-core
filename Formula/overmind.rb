class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.0.8.1.tar.gz"
  sha256 "f3739b1f9e1a3b94f893a6849ad521d94cef9f149959edf2cb643b555977f7a2"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "55526aeb2004cb83613fd48425c9ee1d404f2252fe72300ccc19c96bd11a44b4" => :high_sierra
    sha256 "732996322d3bb15e40fa7770201e322eddab0afd2568afafb1fe6586f883e84c" => :sierra
    sha256 "9772fb4a878e894bbae218d62585745f531368f08646fbd5c83b918e0c668829" => :el_capitan
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
