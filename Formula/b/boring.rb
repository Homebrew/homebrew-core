class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://github.com/alebeck/boring"
  url "https://github.com/alebeck/boring/archive/refs/tags/0.11.7.tar.gz"
  sha256 "8a0a26e48e40dcc8b90c4e95621bd1ba68c5793a10d85d8bb50725a923a18f64"
  license "MIT"
  head "https://github.com/alebeck/boring.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0fbaa7c34fb72dd27461d66b8f7aea30d78d81ea5c10efabdf3140df9d1f6f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dba12360e72ff80eab9e7c8a4f5028a9eb80aef0e0ac79c752e7eb0e365b7dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2dba12360e72ff80eab9e7c8a4f5028a9eb80aef0e0ac79c752e7eb0e365b7dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2dba12360e72ff80eab9e7c8a4f5028a9eb80aef0e0ac79c752e7eb0e365b7dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "25e1d2283e84f441035c414b4b0ee1e3a6dbaa7af011f470153c6e1aa0b92de8"
    sha256 cellar: :any_skip_relocation, ventura:       "25e1d2283e84f441035c414b4b0ee1e3a6dbaa7af011f470153c6e1aa0b92de8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a117b5335ed00dd2388e34d5253f6b52f779a4735eb48b08029761891c3c80c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c3f68efe19a35b7f9c3e6e0ec25b1b48a843e47eaf46577345269dbaac836e4"
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
