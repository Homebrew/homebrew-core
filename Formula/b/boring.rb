class Boring < Formula
  desc "Simple command-line SSH tunnel manager that just works"
  homepage "https://github.com/alebeck/boring"
  url "https://github.com/alebeck/boring/archive/refs/tags/0.11.0.tar.gz"
  sha256 "5610b589c979d070785f06a8a02e9a90f3828b97e0d977608cc2d6300675e69a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d027e74059c5045c6ada1ccccd313c069f38a044423174a66387860f6886f37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d027e74059c5045c6ada1ccccd313c069f38a044423174a66387860f6886f37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d027e74059c5045c6ada1ccccd313c069f38a044423174a66387860f6886f37"
    sha256 cellar: :any_skip_relocation, sonoma:        "47006ba3ff2bc276c2f76636a3f1dd202de352c39ee093a3b82d3ecb971abb26"
    sha256 cellar: :any_skip_relocation, ventura:       "47006ba3ff2bc276c2f76636a3f1dd202de352c39ee093a3b82d3ecb971abb26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e93716c87057e895e6002ba4cfba0454268fa251b537b077f43848c307bc6876"
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
