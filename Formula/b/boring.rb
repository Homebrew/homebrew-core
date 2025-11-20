class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://github.com/alebeck/boring"
  url "https://github.com/alebeck/boring/archive/refs/tags/v0.11.8.tar.gz"
  sha256 "6b31a6046d595fc55496c0cc7654184d22c871729ec274709222e5f34678819a"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4519a4d66c9e2d1bafeef19dfa358e2c56bfda4b2c1070ed251b0fcae9e7fde8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4519a4d66c9e2d1bafeef19dfa358e2c56bfda4b2c1070ed251b0fcae9e7fde8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4519a4d66c9e2d1bafeef19dfa358e2c56bfda4b2c1070ed251b0fcae9e7fde8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4618e05ee175780dca308980515da4f16efc7b62e329f03e1307c67cec99d094"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc712b056d95434baa12289884298df928e7c4394be8b8c156c196fdf5dd9f43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2611d4e6ac1ee88db608c4decf132871021d86a933814f54b7550169ca1eec19"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/boring"

    generate_completions_from_executable(bin/"boring", "--shell")
  end

  def post_install
    quiet_system "killall", "boring"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match version.to_s, shell_output("#{bin}/boring version")

    (testpath/".boring.toml").write <<~TOML
      [[tunnels]]
      name = "dev"
      local = "9000"
      remote = "localhost:9000"
      host = "dev-server"
    TOML

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"boring", "list", [:out, :err] => output_log.to_s
      sleep 2
      assert_match "dev   9000   ->  localhost:9000  dev-server", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
