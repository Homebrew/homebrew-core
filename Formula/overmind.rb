class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v2.2.0.tar.gz"
  sha256 "6c24fd91167f0fd35c60275f1cea9998c1ffab88a6b699731bf88f4e54f23d48"
  license "MIT"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd22cafb2c5437c5e33ea1d7354b6477f743adb23393b9f0c8794cd2ae8ff213" => :catalina
    sha256 "cdb7478361214b56df089ea7038c4747a2430defc6af864c66fe95796a3b5ce6" => :mojave
    sha256 "5304546181f4a8da0604296b277000c16143862a11def6b48cab969e2a34ee62" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "tmux"

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"overmind"
    prefix.install_metafiles
  end

  test do
    expected_message = "overmind: open ./Procfile: no such file or directory"
    assert_match expected_message, shell_output("#{bin}/overmind start 2>&1", 1)
    (testpath/"Procfile").write("test: echo 'test message'")
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}/overmind start")
  end
end
