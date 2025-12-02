class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.27.tar.gz"
  sha256 "c65f8949653a633e0b2f0cb19d881f4155c55febe2e6ab3a1fb7c6a0ae7b4f0f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cba1b7cab964a0077c93f23172a12558b0c67024b8a2957fb28a0d9f304a9973"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cba1b7cab964a0077c93f23172a12558b0c67024b8a2957fb28a0d9f304a9973"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cba1b7cab964a0077c93f23172a12558b0c67024b8a2957fb28a0d9f304a9973"
    sha256 cellar: :any_skip_relocation, sonoma:        "334cc26b6dbff0a308253bdf922b344bcac1c76bb50b00679ee68cdec874cca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0991d99996b97825340205069c4bf8f532d1b9786f489ad4154f0ef8928e517e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93961496074bccd806d03a70cc6af23b9ce3d11617884117eec449b3405a03fa"
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
