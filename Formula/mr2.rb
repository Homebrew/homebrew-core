class Mr2 < Formula
  desc "Expose local server to external network"
  homepage "https://github.com/txthinking/mr2"
  url "https://github.com/txthinking/mr2/archive/refs/tags/v20210401.tar.gz"
  sha256 "3cf2874a5945e79fd9ca270181de1a9d6a662434455c58e2e20e5dbfdebd64c7"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1f7f707256fb17fe77bf076823f7da09f929f0dce93f4a93d6cedce12ea117f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b21b5c834d5d3e9472c21b6fd97a1926f5dbab022ea3fb557165a4aaae50f60"
    sha256 cellar: :any_skip_relocation, monterey:       "b09f149ad6d11c1f589332040539fb8862f56f23b196236b1b9b568c65edba18"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae3ea4a30eecaedcf6a29f0fb046510a76282d26a3c7d4cabbb9502588769ab5"
    sha256 cellar: :any_skip_relocation, catalina:       "6ba779bf8b4ea1385176db98611108ad17aad4319da50cd07db102874f7801b0"
    sha256 cellar: :any_skip_relocation, mojave:         "a1afbf9aeac7c5fb38e63e138ba06eb254a349923887d5fcd530e91f0332dfc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22e8ca90f5ff2463a9fe0df44986146468f425b6f6e0dd4148d889fbf35ada6f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli/mr2"
  end

  test do
    (testpath/"index.html").write <<~EOF
      <!DOCTYPE HTML>
      <html>
      <body>
        <p>passed</p>
      </body>
      </html>
    EOF
    mr2_server_port = free_port
    server_port = free_port
    client_port = free_port
    server_pid = fork { exec bin/"mr2", "server", "-l", ":#{mr2_server_port}", "-p", "password" }
    sleep 5
    client_pid = fork do
      exec bin/"mr2", "client", "-s", "127.0.0.1:#{mr2_server_port}",
                                "-p", "password",
                                "--serverPort", server_port.to_s,
                                "--clientDirectory", testpath,
                                "--clientPort", client_port.to_s
    end
    sleep 3
    output = shell_output "curl 127.0.0.1:#{server_port}"
    assert_match "passed", output
  ensure
    Process.kill "SIGTERM", server_pid, client_pid
  end
end
