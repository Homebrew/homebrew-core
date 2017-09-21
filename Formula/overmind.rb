class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.0.8.1.tar.gz"
  sha256 "f3739b1f9e1a3b94f893a6849ad521d94cef9f149959edf2cb643b555977f7a2"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fce6ae006af7eacc09ac98bed3f404ab7090b2fda7b146738efd0ff5f3ba7569" => :sierra
    sha256 "52bb1e0d12053924a9c13a51763f6ded256d4b51e5daa65199e270c917f382b6" => :el_capitan
    sha256 "487101326fc525458c3aa3de01b37170dfdbb4a5e76a8f8efb34e799043a951f" => :yosemite
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
