class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.4.0.tar.gz"
  sha256 "3f4615233a0330a3a10e35f053f35774826ca13bc25a50c09bb60fe8684c9781"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e98182c45c3365c97c903598c80120f373f118b0e1a10d3883b50051de4485b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f39ec52234f924a4526087d2ce66cb8eab363b234ee8de2d0926fb5ccb65a7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "406252eb464692d8bee409f72df0c6387a787d2637e367dbc68e273d661175a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "215e9838ded02623b5bec887e1b7ce20347eeec3ad7783c4bb85aefa183ae0cb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0863ea00685032b8ad8e638a232c91d02baf1dd6b7019f71d335a3a5ac4601f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba29d66dfa64a13d9cc0381fdc09ff735ae3437d11a289505e89cc337310eaa2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/hwatch.1"
    generate_completions_from_executable(bin/"hwatch", "--completion")
  end

  test do
    begin
      pid = fork do
        system bin/"hwatch", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "hwatch #{version}", shell_output("#{bin}/hwatch --version")
  end
end
