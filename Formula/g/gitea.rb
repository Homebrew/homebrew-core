class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.21.5/gitea-src-1.21.5.tar.gz"
  sha256 "567245e824acb1062cf3220a997bf160787609f2e2261b8ab6345da8a2101b1c"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02e9c67cf94f15d42890d5db7bd585ae8c06298699543462dabbbbb6d6cbc39c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a1f13b7f50e0118caadcb82a0fda273dfcf7d9362de9349316c0f0aa77051f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97e76cf189ddcc4693b96c982d450b7456d4e9fac4ef9192279226a47af72b4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f8aef97c0d240a9320f23ac703c6949ccfb4fa94a6044d8b6beb492013ab6c0"
    sha256 cellar: :any_skip_relocation, ventura:        "12b567bb5b34a913d2044f610c20b26727944e9b966e42c471d606ca284c019a"
    sha256 cellar: :any_skip_relocation, monterey:       "d830a9375d96e31f2216a223d5d6fa5b8b9c0d9b268c9e2b8b47aaa3cdb69910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeecd719ed223c2c46d1490b8467eb750c1d9f9a26194252018649842b4dd9a8"
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
    sleep 5

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
