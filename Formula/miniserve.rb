class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.19.3.tar.gz"
  sha256 "3165e3847d5aa52d47d097f13a2769e6ed2b5f360bfdc0ac5aa80956f785cd42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb815b7af08209324d284c4340991ecb52394275ba9fdecb9ff854c341fb8558"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65604b3c08dce7471fabd1f55c84a48ab0b65bf3f9d1768348ce858f14622f4b"
    sha256 cellar: :any_skip_relocation, monterey:       "7e3d152df7cf13afdc795c0203a0b5ed2fb769963692f1e4cd7301c7be031138"
    sha256 cellar: :any_skip_relocation, big_sur:        "483dd3c2e3a7253b30bf5bd3dd0ceae83cb4cdc7e71c266211a502910fee09c9"
    sha256 cellar: :any_skip_relocation, catalina:       "b1902bc579d660d5f4942a737fed3ccd112c229b469d66462dc793a9f8180615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0333365c5df69c7c39a7f73e9c266afb8dea0cc1bc61a0a4ee9a51becee5ed26"
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
