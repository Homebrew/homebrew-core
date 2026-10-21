class Gitea < Formula
  desc "Painless self-hosted all-in-one software development service"
  homepage "https://about.gitea.com/"
  url "https://dl.gitea.com/gitea/28.2.0/gitea-src-28.2.0.tar.gz"
  sha256 "b8ad80f8a79ea42fa5cf52bdc3d5fd3457bb6abd6bd57cfcfab6a5ad4f31c3dc"
  license "MIT"

  livecheck do
    url "https://dl.gitea.com/gitea/version.json"
    strategy :json do |json|
      json.dig("latest", "version")
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "75b2192673f463e8e1b7dbe0ff022bfb235aa69c66574de1249d92c28f7cc65b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "255f8b2074219fc5a88fae48905b4a5c07ef0ea834954ed648c1af480b9fd99c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edfd5c74dd96a95734272ec09346a5fc41e01ebc7a0af8b8569d23de5e3739b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6e52b1e8f99eb111289663066e9c94ace739f6f5faf475761f4ab0684fc9ba67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6bbd3359ac42377459b51e4c63b5f1f1389041f2ef98ef461c4140f8e6492102"
  end

  head do
    url "https://github.com/go-gitea/gitea.git", branch: "main"

    depends_on "node" => :build
    depends_on "pnpm" => :build
  end

  depends_on "go" => :build

  uses_from_macos "sqlite"

  allow_network_access! :test

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
