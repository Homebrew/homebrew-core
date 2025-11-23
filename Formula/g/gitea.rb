class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.25.2/gitea-src-1.25.2.tar.gz"
  sha256 "b8006b388ced46627eaa53fbe05e04289ec6441a89d0f0b1f8ee33b4eec7235e"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d92b1096f9181a5b5e033e4e83fc381b00229b4fc2f2be9aa2c6b9e7e906de8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d0904afe3ee653be0b77013f981fdabea875f9eb3594fbcfec565cd4d3edecf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d14907739e5fc8bbd9de219fc48129f96e9146c62ae180e9c0f26b911f5041e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6903eb65bebff1c6c09b5e01b528489b50a10f5f65bba58602d2c4fb627729f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd58d0f9c53bd28ca918c30421deffe7c84a2f6840f633d0fa0138fe70ef170e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcece6c11fabf7a0f81ff3fb181ed1f1511b1496edff9459dbb7a0f81bc2cf2a"
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
