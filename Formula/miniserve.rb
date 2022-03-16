class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.19.3.tar.gz"
  sha256 "3165e3847d5aa52d47d097f13a2769e6ed2b5f360bfdc0ac5aa80956f785cd42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74df4b1a34cc13ff796ff180e4daf2e784eb044ea9268bcee73eb2b020f13698"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "344e126f00c80fec327451a3e1f0a92d32015a4b4617a1ae3ff979b8c5c38be4"
    sha256 cellar: :any_skip_relocation, monterey:       "555aec1fbbd9ea377f962597a2cb3498ce0d71d9e117fd5f1c2a6f42f20c2c1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "99f76bd1838d7bd777c33d48e92730fb98486b7443428efbcfe475e26352ed64"
    sha256 cellar: :any_skip_relocation, catalina:       "1ecd148ecf5fe3d9b9b41ec21d96e88f79942306b5902b333b3d0775d315e34c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b46537d9e6e9259276bd8f903fa9dd44c484379c97a85d45d8b9d1d9210b4f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "bash")
    (bash_completion/"miniserve").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "zsh")
    (zsh_completion/"_miniserve").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "fish")
    (fish_completion/"miniserve.fish").write fish_output
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/miniserve", "#{bin}/miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
