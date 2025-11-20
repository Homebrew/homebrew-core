class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.25.1/gitea-src-1.25.1.tar.gz"
  sha256 "127f9d6efce69cc9cbe92b6cf84b98709b458407f9b21c6d15b007d68b656148"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2d9fa4a3b7924674d6ef3cc7558681c95595eb1f39f953b1da2f68d5109ddc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d117c3dd25dd687da25c45c412c7c4b64652fda44d581cc3ba279a3f1f17fe35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc47a9a2d734baff76b412da9b263308c5e9a60bd3076e5e54d422eb234ad2bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "352dee8e9cdde93b4858cb03fdadf4d0363c246920423e2d542a400ca14ee083"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16cd0f0251b27a01c901e42c2717e7e378a55440c5f6551a7834f584f3c01ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7dde2949101fee9126238a97152aa351e9eabd6508263e7631bbac552a91d21"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "sqlite"

  def install
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea"
  end

  service do
    run [opt_bin/"gitea", "web", "--work-path", var/"gitea"]
    keep_alive true
    log_path var/"log/gitea.log"
    error_log_path var/"log/gitea.log"
  end

  test do
    ENV["GITEA_WORK_DIR"] = testpath
    port = free_port

    pid = fork do
      exec bin/"gitea", "web", "--port", port.to_s, "--install-port", port.to_s
    end
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match "Installation - Gitea: Git with a cup of tea", output

    assert_match version.to_s, shell_output("#{bin}/gitea -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
