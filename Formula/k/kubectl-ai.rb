class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.25.tar.gz"
  sha256 "8ab90ee9e2d6ccc31cb266e5adf1bb82dfb2073ee92e3b33274bd83e12ee6174"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d5b462463dbafbab13cf6eda9cc3459b343d06fb0c9339019ec99b25339fd9c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d5b462463dbafbab13cf6eda9cc3459b343d06fb0c9339019ec99b25339fd9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d5b462463dbafbab13cf6eda9cc3459b343d06fb0c9339019ec99b25339fd9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd325a6886819d1384b0f93dee1520c3eff0abd00eed9d7df74aa933180ca762"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a19887b9be146250147662b0b87c6a57c26c2d4496087b890b03d5aa0c7b297"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    generate_completions_from_executable(bin/"kubectl-ai", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubectl-ai version")

    ENV["GEMINI_API_KEY"] = "test"
    PTY.spawn(bin/"kubectl-ai", "--llm-provider", "gemini") do |r, w, pid|
      sleep 1
      w.puts "test"
      sleep 1
      output = r.read_nonblock(1024)
      assert_match "Hey there, what can I help you with", output
    rescue Errno::EIO
      # End of input, ignore
    ensure
      Process.kill("TERM", pid)
    end
  end
end
