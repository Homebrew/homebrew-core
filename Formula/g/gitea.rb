class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.20.3/gitea-src-1.20.3.tar.gz"
  sha256 "727eb56799d8326cd2a07703a17c2e866f88327ebe88860f8bb2b1ccefdbe4dc"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1254a12d6d8146b04d9c2e620e9826db014c05ec42731df927ea1b93838b4476"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "160e9ebd20434db8460cf667125c37a407e5a45b99036fe7a35d7f0fa0a8bc91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d71c4c60e1809797f7d105babddf85ecf6c174f9ea32b1082ac9575da3d13a6e"
    sha256 cellar: :any_skip_relocation, ventura:        "3334fdec1edafe11007d84cbd06d2b4a4ff8a5f64064edaf99f793903fdaeac1"
    sha256 cellar: :any_skip_relocation, monterey:       "7d8a00ea67a3231b47d6987b3f7ec7779bed474fe000f4dc46c8255baaae7b16"
    sha256 cellar: :any_skip_relocation, big_sur:        "92edbec2f327bcda77415fa87c645da535172780392a144ce80a0463049cf419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14f6c17b21afc567cb66f1af44ed4b47dc1ad93c3315a1f019ea753286a8a3a8"
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
    run [opt_bin/"gitea", "web"]
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/gitea.log"
    error_log_path var/"log/gitea.log"
  end

  test do
    ENV["GITEA_WORK_DIR"] = testpath
    port = free_port

    pid = fork do
      exec bin/"gitea", "web", "--port", port.to_s, "--install-port", port.to_s
    end
    sleep 2

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
