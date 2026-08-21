class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal"
  homepage "https://herdr.dev"
  url "https://github.com/herdrdev/herdr/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "60453051025ee44ebf055d26cdaf665a0accd99a992cddd22c166a26c49cd161"
  license "Apache-2.0"
  head "https://github.com/herdrdev/herdr.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9515bf9aa4f9f9499602f85f0bcb4442e3091e012377c718aadf9b69cf264cac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45ca2eceb496bcdfcfc0ac84352f4a765101e9815d592d722b60ea02f7391fd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77f35ea0c42d53e62781a7b57c2f0b0cf51d00ac7aa473938be549608ccd320a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1be48fb5b7ad7d7c32c5401e3d49d574a0bd47131d8ccc9cd3f6ed147dcd259e"
    sha256 cellar: :any,                 arm64_linux:   "3199b6cbd0ef588ddc0d342c8c9b3cada72c088a6d457882a887eaf6a3554d39"
    sha256 cellar: :any,                 x86_64_linux:  "41959b034969afae23abb18433cd425ea5e2b1cf9f0fa134c55b89c29b44bd14"
  end

  depends_on "rust" => :build
  depends_on "zig@0.15" => :build # upstream issue, https://github.com/herdrdev/herdr/issues/285

  def install
    ENV.prepend_path "PATH", formula_opt_bin("zig@0.15")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"herdr", "completion")
  end

  service do
    run [opt_bin/"herdr", "server"]
    keep_alive true
    log_path var/"log/herdr.log"
    error_log_path var/"log/herdr.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/herdr --version")

    ENV["HOME"] = testpath.to_s
    ENV["XDG_CONFIG_HOME"] = (testpath/"config").to_s
    ENV["XDG_STATE_HOME"] = (testpath/"state").to_s
    ENV["HERDR_CONFIG_PATH"] = (testpath/"config.toml").to_s
    ENV["HERDR_SOCKET_PATH"] = (testpath/"herdr.sock").to_s

    pid = spawn bin/"herdr", "server"
    status = ""
    10.times do
      status = shell_output("#{bin}/herdr status server")
      break if status.include?("status: running")

      sleep 1
    end
    assert_match "status: running", status
    assert_match "version: #{version}", status

    output = shell_output("#{bin}/herdr workspace create --label brew-test --no-focus")
    workspace = JSON.parse(output).dig("result", "workspace")
    assert_equal "brew-test", workspace["label"]

    output = shell_output("#{bin}/herdr workspace list")
    workspaces = JSON.parse(output).dig("result", "workspaces")
    assert_includes workspaces.map { |entry| entry["workspace_id"] }, workspace["workspace_id"]
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
