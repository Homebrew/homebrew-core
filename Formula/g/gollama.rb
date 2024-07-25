class Gollama < Formula
  desc "Go manage your Ollama models"
  homepage "https://smcleod.net"
  url "https://github.com/sammcj/gollama/archive/refs/tags/vv1.20.5.tar.gz"
  sha256 "17335e526725cd7952f2ac2b3a9d7f5f556cc0aba24fa14e894e88cfba108773"
  license "MIT"
  head "https://github.com/sammcj/gollama.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w -X main.Version=#{version}", output: bin/"gollama")
  end

  test do
    assert_match version, shell_output("#{bin}/gollama -v")
  end
end
