class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.0.4.tar.gz"
  sha256 "6a2219044fbd68757f1d1551f6750dc639b10cf9d0eab036dda25f1a0879bfe1"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e984c8bfd67cdc219d2c86211bcf4606d1dd451d40717ac9399d33fa358d73e" => :sierra
    sha256 "f9bf895436423897e82919f4d3006ee91b18da203ef94aaf477a5f16ce472a47" => :el_capitan
    sha256 "6015e7c58b4adc43418d886e3023a3cadbc4e33917e61bd80afe83d1e38dea50" => :yosemite
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
