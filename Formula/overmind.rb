class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v1.0.7.tar.gz"
  sha256 "9ef5512b2b72db0110eafff8864357954b2516f79ecf0b3c040327512722539e"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "163c53d8701033b5bf0620a12885a6ab0fe0a6aead76b860e9d2eb875d071e00" => :sierra
    sha256 "206f6923ac67519eb0ca053b2f384492051c68f6735836f02b1c405451a8b03e" => :el_capitan
    sha256 "967c9715377837251936301e42a332bd752a591aa9bdcf8f9cffeaff31572319" => :yosemite
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
