class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "fe86ab82fb857207873ad992a77ffec491dbbabe29cf1b64ac1a096ff84cd9b6"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/kubectl-ai"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbe70c7f12aa66b64f7d777f85e3ad54fe1235e2208a10dee9403103a5711268"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbe70c7f12aa66b64f7d777f85e3ad54fe1235e2208a10dee9403103a5711268"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbe70c7f12aa66b64f7d777f85e3ad54fe1235e2208a10dee9403103a5711268"
    sha256 cellar: :any_skip_relocation, sonoma:        "4532552bc0519224591adbff763fd84b65c1ea2fe088312b325aa52cbb8d3a25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc94eccc17a0b33024d5f86a4cfee092187b8058d5a75c2010c91b17dfc65052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6844931a7e594874861a2c51cf01c51c26116ef63e50b088fd3de7f454af69f9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    generate_completions_from_executable(bin/"kubectl-ai", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubectl-ai version")

    ENV["GEMINI_API_KEY"] = "test"
    PTY.spawn(bin/"kubectl-ai", "--llm-provider", "gemini") do |r, w, pid|
      sleep 1
      w.puts "test"
      sleep 1
      output = r.read_nonblock(1024)
      assert_match "API key not valid", output
    rescue Errno::EIO
      # End of input, ignore
    ensure
      Process.kill("TERM", pid)
    end
  end
end
