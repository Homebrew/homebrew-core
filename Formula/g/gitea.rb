class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.27.2/gitea-src-1.27.2.tar.gz"
  sha256 "f6580cc326775969d0e6408d4eefd25e05fa3d4e1803deb2c0566235db809989"
  license "MIT"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62b6a0a893a851d34252a59e946f8f5a2da8385ee10c7300926876bed2249ea6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd5c80e9eadbf35ae5d55834d737d643d1455120a6484e2b3382c6e96efe54d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "949781b71b06be9fb4987829060559415787e82cd2f6642b80e50da6fba7ea6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bffd28c535b45581847c6ed39cc2ed9be58c0aff9225214e87c21ab39c9570ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c34371c29ab7d68764d65e25c473a3b742106cf848db0b50998e6c4f45f9011"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "226d5c8e8f5ffbaf3774edaef525f4397cb0b863e4af8b53d65e9def104eb32c"
  end

  head do
    url "https://github.com/go-gitea/gitea.git", branch: "main"

    depends_on "node" => :build
    depends_on "pnpm" => :build
  end

  depends_on "go" => :build

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
