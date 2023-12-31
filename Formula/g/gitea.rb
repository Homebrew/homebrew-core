class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.21.3/gitea-src-1.21.3.tar.gz"
  sha256 "b490bda7bfbe95bde50f4c98478a80b4539344140ad9290d083e9393e83d33bf"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ce540b71367117f1b7da11f0cac64f6c54ab63e450e7247bc8731b4e854ce79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4dbb3fa10ccdafc3d4627227976acc30cd66450d7903aa7ebaa08a70a7fd868"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c62161abd75ca2bf0f214ae9ebe5ec4b10785ef03e9a2585ccebcbf8068a38d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "090d403f359ef60115aaa0298a94303ff36df62e8e53f7e0f73c51e34f602c46"
    sha256 cellar: :any_skip_relocation, ventura:        "69769a1318ccc77bb4b0b704ffc3df0d259cd9a71238a5c657eb4e6a6f6fbd43"
    sha256 cellar: :any_skip_relocation, monterey:       "2cad2177bd7ecc989afc5bbf5fa4ca08986eddd4598d00a5274527d5cc472ae7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a15176997cc1718bb706d959f3138d90d93cf242bf61aaa4af4b3e7c011f73f1"
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
