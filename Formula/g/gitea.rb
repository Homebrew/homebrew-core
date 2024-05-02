class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.21.11/gitea-src-1.21.11.tar.gz"
  sha256 "4f1cac5f0de555d57f86520bced33e0fbc08a5ea977e0940cbb024d80c679443"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64df89d625c696dc2b082b3f29753de81285065e74eb0fd3b5f3ada0c453676d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6945595be9c2a142aea60dfab914974054a83c182646bc42e9e10fb745ed2dae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92e80d2ce171880cf493609fc3507f0b0a0217b00655077cf0804450d7eb627d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7741fce15b796d927107c69f82c20382532f7f64377602ac8537211f854b9a83"
    sha256 cellar: :any_skip_relocation, ventura:        "5c06058857392528b8b09cd0d72b52d188fcd0fa67be5d64e5811e78e5fe5ed8"
    sha256 cellar: :any_skip_relocation, monterey:       "7ac141f6091857bb913da56463e32e529dba4669bac6a5613e1702c58f3762b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69a99897edc919cb03eabfc539a8fffe084dcd7c17531f28d2f696026792f55e"
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
