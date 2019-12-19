class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v2.1.0.tar.gz"
  sha256 "dfd5e562fe9d94cdcb3048be99280dab897ad57d54178b74dab023b49308a534"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e5aee58153a72b8ad07f9bb8fc6edc54253396ff6ac09edd656990afc75e148" => :catalina
    sha256 "cd9943966640124680b2a2f9a1ace5fb50fea0e2401bc5206e096ad377f0a27d" => :mojave
    sha256 "caca34564409a66cf16c544a9b6065db06b4c29d71725118dcc3de3dcaf75156" => :high_sierra
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
