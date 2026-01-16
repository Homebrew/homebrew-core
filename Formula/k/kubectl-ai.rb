class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.28.tar.gz"
  sha256 "b9c6edc1db0238ec79049c4090fec57023a00e13f72e1125cdbefe7ed10eb948"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc8ce823e627236a001d5c6570ed3b4e8f6ffdadaae9512c9c172d99c32d4a11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc8ce823e627236a001d5c6570ed3b4e8f6ffdadaae9512c9c172d99c32d4a11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc8ce823e627236a001d5c6570ed3b4e8f6ffdadaae9512c9c172d99c32d4a11"
    sha256 cellar: :any_skip_relocation, sonoma:        "e500e221569afbb81537c72e6af42591169bec835cce80c96e9a2bd5b249fb1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07cf3ba218c271a0822d2bc17ba4ea0c425502746dc2269d2de3921b0ec4e270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "392a25015a5fc821f8523acd4b837fd3d84dadbc94283ea59f79e6e8c95507a1"
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
      assert_match "Hey there, what can I help you with", output
    rescue Errno::EIO
      # End of input, ignore
    ensure
      Process.kill("TERM", pid)
    end
  end
end
