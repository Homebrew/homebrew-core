class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.2.1.tar.gz"
  sha256 "114a51b45fe02205d28db1fb1b6e23e501c3935f7d3b8862e7db70c41153542f"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c5aa09dbc0d6d00ec9e4b6f4ae56a9ec65b21992cad837996c50db403a0c261" => :mojave
    sha256 "1d46dfcd6a60c9e504251302ff2c65f84f575c68f1b7315cd847e52762d83c63" => :high_sierra
    sha256 "db203925a49561a4841a7c888b5a3d8b15857b62fa1d4398bfc5ade14481bf1b" => :sierra
    sha256 "daf31f46ad521fdb79d74e6c7ec995e109f4714b68ac0fa9ae7d4a010793f0a7" => :el_capitan
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
