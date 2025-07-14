class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://github.com/alebeck/boring"
  url "https://github.com/alebeck/boring/archive/refs/tags/0.11.5.tar.gz"
  sha256 "132c98e67165fa78e01ec89ea349ed767433fbdf3994b88f87761e4d41c4a3c8"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa648fed1371ebf70a7bf6e074b42fef429c894c83716c83cb68e4d85115b7bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa648fed1371ebf70a7bf6e074b42fef429c894c83716c83cb68e4d85115b7bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa648fed1371ebf70a7bf6e074b42fef429c894c83716c83cb68e4d85115b7bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "13af457719b2caf176eaad23a801f58d5451bceb831376724c5a02b632711a25"
    sha256 cellar: :any_skip_relocation, ventura:       "13af457719b2caf176eaad23a801f58d5451bceb831376724c5a02b632711a25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71f8c0338971cfb88d2a3449af922f3baaaf083f0a1fdd42708ab1b3ac496ec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b74a7276ffb6e139fccc3f491521db8b986a99efe6f5607f05aa22aebdb79f73"
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
