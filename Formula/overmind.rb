class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v2.0.2.tar.gz"
  sha256 "110a271298223251005266b915432196b340f8540de1b4c1489973537d9b3bb1"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cab67f961cff86649aa817a0e73fac8227e8674cb475e12aa8c07883f8db2938" => :mojave
    sha256 "70cbb5075904b143799ac25134daccd0465282787c2f355ef05780bcf2902395" => :high_sierra
    sha256 "9934a99f38852e83c8d3c0b2db16619ebea10917605e3d4ec136fa9fa1f16141" => :sierra
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
