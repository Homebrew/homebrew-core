class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.26.2/gitea-src-1.26.2.tar.gz"
  sha256 "ce1462ad93dcbf3221a452457008b8159cbab3d0c93958179b88649df1e401cf"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea1c734fc9656d5600e1a7da8633b5ec86a7b870cd81782573e4322cd4a2fcc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c57339798d6454744d921a9f15709591dfbf098424894fe0f9fc044c975ea23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40d2681950f2f014806b77074e1263d85546834a3c5163dfe27c4f28204dfeca"
    sha256 cellar: :any_skip_relocation, sonoma:        "043cccab3aaf30c662d4b8f71f5b19c1f5ccc6468e35ff76ba1bf199b769d290"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce64c182dfd45a557eefb42233b1baeca13585e45408a00b1f73427d12f6005c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0236f508dd099ef9127624b3797bae170fe5ab6624296e6f347cd430c1d17845"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "sqlite"

  def install
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea"
    system bin/"gitea", "docs", "--man", "-o", "gitea.1"
    man1.install "gitea.1"
    generate_completions_from_executable(bin/"gitea", shell_parameter_format: :cobra, shells: [:bash, :fish, :zsh])
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

    pid = spawn bin/"gitea", "web", "--port", port.to_s, "--install-port", port.to_s

    output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match "Installation - Gitea: Git with a cup of tea", output

    assert_match version.to_s, shell_output("#{bin}/gitea -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
