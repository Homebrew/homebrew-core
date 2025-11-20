class Ktea < Formula
  desc "Kafka TUI client"
  homepage "https://github.com/jonas-grgt/ktea"
  url "https://github.com/jonas-grgt/ktea/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "fc8cc2ec922af14845885e6eab79ff640b265bc6567ab0243b15ee9811626515"
  license "Apache-2.0"
  head "https://github.com/jonas-grgt/ktea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d646661116ad573a62dcccf6522c27f9324bff4a0f9ead96bca25c6ce91b4ae1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d646661116ad573a62dcccf6522c27f9324bff4a0f9ead96bca25c6ce91b4ae1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d646661116ad573a62dcccf6522c27f9324bff4a0f9ead96bca25c6ce91b4ae1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dd05e0ae89d02c245b926b6cc0a79369e2fb97edd48d77f345f9e119cc6f544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "347662cd56f5a0675fde15ea028516095acb3722fececd1af8afbbc775366e5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bd45f8ca6c854f040024ad921ef5df07e19060b62b7ff2487ecc552dd6d384e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "prd"), "./cmd/ktea"
  end

  test do
    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"ktea", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "No clusters configured. Please create your first cluster!", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
