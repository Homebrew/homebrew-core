class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v15.0.1/forgejo-src-15.0.1.tar.gz"
  sha256 "c57b8aaf0f5e4b041f6e47238bff0366f47ef2757ac3bda588300e588d8142fd"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3eb1e051ad570f65cd71b9794fa6124c241860bc1f934a5c21c174594f0153b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99239756f0c44434cddb4bdea708771a54424626e47a4d605647817b37089e8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d46d7b89a5b1c73bafee2d43a3a3d6ceee45954945ce8c41e174d2b32884177"
    sha256 cellar: :any_skip_relocation, sonoma:        "5771c3b8fcc173b5f89b404f03d74dc94549770bba1651125662c6f47239ea21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25cadba41c6cdf355d0727790ced211a3c446b5ce78670ebacf4b9767cfdbbe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceed9e3ac3afb59ff73331d84effc08c979262c6ce35776236b6fb388cb7b080"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  uses_from_macos "sqlite"

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    ENV["TAGS"] = "bindata sqlite sqlite_unlock_notify"
    system "make", "build"
    bin.install "gitea" => "forgejo"
  end

  service do
    run [opt_bin/"forgejo", "web", "--work-path", var/"forgejo"]
    keep_alive true
    log_path var/"log/forgejo.log"
    error_log_path var/"log/forgejo.log"
  end

  test do
    ENV["FORGEJO_WORK_DIR"] = testpath
    port = free_port

    pid = spawn bin/"forgejo", "web", "--port", port.to_s, "--install-port", port.to_s

    output = shell_output("curl --silent --retry 5 --retry-connrefused http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl --silent http://localhost:#{port}/")
    assert_match "Installation - Forgejo: Beyond coding. We Forge.", output

    assert_match version.to_s, shell_output("#{bin}/forgejo -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
