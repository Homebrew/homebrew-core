class Overmind < Formula
  desc "Process manager for Procfile-based applications and tmux"
  homepage "https://github.com/DarthSim/overmind"
  url "https://github.com/DarthSim/overmind/archive/v2.2.1.tar.gz"
  sha256 "eeb81045a8c32d8386521e110b34178c5cbeba5623107d286855710a0e7fedbc"
  license "MIT"
  head "https://github.com/DarthSim/overmind.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "de2bb40dc19a0a9d1b96a87cabe6dd408157634781a094f1c7dfe63ba82e602a"
    sha256 cellar: :any_skip_relocation, big_sur:       "da6500e570b06929b27d353231742e8fe7f1f4c810be0a68636b9c5d7dbaf1b4"
    sha256 cellar: :any_skip_relocation, catalina:      "4dafd6967b24d5d11861f665724a642b38f4c03039af3ae57bdb563144ecff7c"
    sha256 cellar: :any_skip_relocation, mojave:        "67280f3226318b61b7185dc0156dab62539a541bdc99a5c91196f6c3da1af05e"
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
