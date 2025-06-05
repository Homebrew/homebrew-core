class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "1a046645543c971e19407e93f7f6f7c45c115e3c256c078d0b21c10150d4869d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e8e865c902c74ade666ae2b0856ab64d0638061c0df24347cfd91c76e0782cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e8e865c902c74ade666ae2b0856ab64d0638061c0df24347cfd91c76e0782cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e8e865c902c74ade666ae2b0856ab64d0638061c0df24347cfd91c76e0782cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "abec5a1c68d2e1b1a3c7677883515a72f115878b2691b5569d60c1ebf8be0195"
    sha256 cellar: :any_skip_relocation, ventura:       "abec5a1c68d2e1b1a3c7677883515a72f115878b2691b5569d60c1ebf8be0195"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aef37269709afc0e92ac134901e6600241a3d028af29f2aa78432705352e48ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd"
  end

  test do
    assert_match "kubectl-ai [flags]", shell_output("#{bin}/kubectl-ai --help")

    ENV["GEMINI_API_KEY"] = "test"

    PTY.spawn(bin/"kubectl-ai") do |r, w, pid|
      sleep 1
      w.puts "test"
      sleep 1
      output = r.read_nonblock(1024)
      assert_match "Error 400, Message: API key not valid", output
    rescue Errno::EIO
      # End of input, ignore
    ensure
      Process.kill("TERM", pid)
    end
  end
end
