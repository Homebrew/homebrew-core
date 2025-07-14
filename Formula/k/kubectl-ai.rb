class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "e8f984a9966e7d663c24c476eb05fd18cafc2431646fe33e4be127052a7dc83d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dbff86ea625c3963ce9a314c6d870863bea01eb65d27283c24d02bcb0ce44ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dbff86ea625c3963ce9a314c6d870863bea01eb65d27283c24d02bcb0ce44ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9dbff86ea625c3963ce9a314c6d870863bea01eb65d27283c24d02bcb0ce44ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a175b7f75ced9f77f7f115fbca7edb520ca2c70ee438572ba97282c93e4105b"
    sha256 cellar: :any_skip_relocation, ventura:       "4a175b7f75ced9f77f7f115fbca7edb520ca2c70ee438572ba97282c93e4105b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29adc876c354c2c97b1059d7b262ee5bb916945b96dff3a8fb259a2f387cb202"
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
