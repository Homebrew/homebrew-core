class Jqp < Formula
  desc "TUI playground to experiment and play with jq"
  homepage "https://github.com/noahgorstein/jqp"
  url "https://github.com/noahgorstein/jqp/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "c70e83975edb1c1dacb0fb067a0685e9632e21360805ade3dda03e54751e4855"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aad8b70dd5386d6cd26c7aed40cafb238ba26175ca3592c0ccc9c29720ff82b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aad8b70dd5386d6cd26c7aed40cafb238ba26175ca3592c0ccc9c29720ff82b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aad8b70dd5386d6cd26c7aed40cafb238ba26175ca3592c0ccc9c29720ff82b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a1f293efd1fdbd3ba47f82e3f14a87dbd23c2e06844cf6b856e3ae837bcbea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58a43e2ab2c33c66ce1756830fa2f0f871135f216967ce847bccc61517446c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e402ca44a3bcb9ca8ce67ac679b202c548019b7f57042ba153c5a72fed04ab1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"jqp", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jqp --version")
    assert_match "Error: please provide an input file", if OS.mac?
      shell_output("#{bin}/jqp 2>&1", 1)
    else
      require "pty"
      r, _w, pid = PTY.spawn("#{bin}/jqp 2>&1")
      Process.wait(pid)
      r.read_nonblock(1024)
    end
  end
end
