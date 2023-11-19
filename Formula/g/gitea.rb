class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.21/gitea-src-1.21.tar.gz"
  sha256 "5fc06a5147d779a583fafb7c860ca998352e6f6392f9e3218e96076e11f62a21"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54013543460fda1fabef3e09eafd889ba5ed0ffdf0da5967ee46e0486c1318af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "275b178bbce0478cae6553703520c9c07e4e54268a9dbc6a45a1b231eb735408"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "765273bda54f991d8fe610f42bc2a6a0b74f8823f2abd682962a8c6f245b1d33"
    sha256 cellar: :any_skip_relocation, sonoma:         "d845cd47bff2050617de06678278cb4bcd587a4164c83fbdeef8b0a3e9cc14d6"
    sha256 cellar: :any_skip_relocation, ventura:        "f3574cf9de60a09536fdc65b8b9d862e250a951bb53d528937ca457005373488"
    sha256 cellar: :any_skip_relocation, monterey:       "0e3acc19fb51b9e6071cd5067cf74a8fea788d5b1b33aadf8653d361d8390422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e6205de0786c4c6e6115ec1711cf78fb9284194661437fa8b1358f2af419362"
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

  def post_install
    (var/"gitea/custom").mkpath
  end

  service do
    run [opt_bin/"gitea", "web", "--work-path", var/"gitea", "--config", etc/"gitea.ini"]
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
