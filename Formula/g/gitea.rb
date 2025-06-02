class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.23.8/gitea-src-1.23.8.tar.gz"
  sha256 "0ff96c1b7cc0960b5b9d34bd978cedc0f856a168654838bdef3551621f049717"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42de7b65a4c03b105051a9d2ddb7488f315e4f671fa5161471b2b7c2cc2f1e65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe0b05e4f4ee0c2e90390b8b23704fb9bb8f70c48e8035f6105647d6a5cad459"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a78e870f28f58c4cc2c57cac38202b6f2604ace9993c27a8df2c42b678bec4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5262e084497a1b4c679e665eb6d4ce06f8d343c96e2e65dd8af3dfdb386f50b"
    sha256 cellar: :any_skip_relocation, ventura:       "9264a1e0d3fd6bc2bac7dd1320253b8aba7eb18944eca6ee14aa129a41263daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e754e10538c0c2d4432ebcae1f97781f05097463bd44f52bd61ed735c459538"
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
