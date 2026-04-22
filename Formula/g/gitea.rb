class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/1.26.0/gitea-src-1.26.0.tar.gz"
  sha256 "9515a679c6fb34e4287951512437b4f6a480cb6fa96d90316365d21364c44b56"
  license "MIT"
  head "https://github.com/go-gitea/gitea.git", branch: "main"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f8ce00bf3fc47bab6d91844afc007fa7bd0efce0ed7509d9283759bb3a3d29e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "163546c998cb26fec2587dbdfdd86c76af8ae7a9381b713cd9b83a02b064b538"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69c85fb04576bef1affc3e85f532e7d93fc2c97dbe6f5bc26bce27e0d30b1595"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7ff7cc26e94e1dfd0d1f63d62c1e7b7688d5068326f44874ace13b61fa54e3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7379ee32139e0f24c3a0cfbecb0b269f439574a8ee093b6844977628442007b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "341edfb445b747d00b66ec9fb63d626f28cdbc717fb00c07dbdd9d5bdaf1356a"
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
