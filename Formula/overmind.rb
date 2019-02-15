class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v2.0.1.tar.gz"
  sha256 "71f41691d8886454e151d30d7490d9ef8599ffc4c1e77ac72934dddf3371dd08"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e870df537a9d1a7194bd3f9e746e6f3cbbb7385fb4ecab971ce4f07d2eaec0f5" => :mojave
    sha256 "5efb298bfab60637ea3df6d247e223ce471d9653ee34fcb912d7e99617e59876" => :high_sierra
    sha256 "e00eae9726eb3f1f33162e4c16c0133f03fc927f565464ecd27e6bf5e5416227" => :sierra
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
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}/overmind start")
  end
end
