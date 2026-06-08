class KubectlAi < Formula
  desc "AI powered Kubernetes Assistant"
  homepage "https://github.com/GoogleCloudPlatform/kubectl-ai"
  url "https://github.com/GoogleCloudPlatform/kubectl-ai/archive/refs/tags/v0.0.31.tar.gz"
  sha256 "a16ccc914fb957e59b7d03f2c707672366ec4444e5c34777361f2efea3e732f3"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/kubectl-ai.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "991b5937191e5f5993794193b6683b2ae65b9a87d7b1e5b95b550b42da45f05e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "991b5937191e5f5993794193b6683b2ae65b9a87d7b1e5b95b550b42da45f05e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "991b5937191e5f5993794193b6683b2ae65b9a87d7b1e5b95b550b42da45f05e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d68ad422989225a10788a66c305781938229c6a575d5143c975d493369c6117b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99e2f0375cc23481367171bb96032eefb3acccd90b6524f20542ce712d6d5789"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47af7ae2c7480d97939b42c534c92a4948c48aaa102d046c1d0e028d8c70db21"
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
