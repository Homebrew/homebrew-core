class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v13.0.3/forgejo-src-13.0.3.tar.gz"
  sha256 "2054f0dce0eb8be6e1a8e765d931ee515241e09fe6928ecbb698447c73c11e6f"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cbc964caabf7dc884834c4fd7d97d5647628d31774c0d35c42ec9e3cd4ccb59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac06646e84f83d7e99aec19c0e1ae6989887e0c043ff521289ac2868fd710a33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cabc41ecb87dd4b9a55a2bfa059b2d8c579aaf95ca100ee35b399f773e8e156"
    sha256 cellar: :any_skip_relocation, sonoma:        "d1d528294740d54d394b03ffb2e5c93aa06a3e759bdd6d5f7f041e9fbac139e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a37fd1f52aa87c0255df9fb1f55bafbabd38c7e33e2f28d57f0872deba5d9ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a4e8da9e1af872f758842cc306b826505e99c0eb2f3edb881860b3ad6191e8"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  uses_from_macos "sqlite"

  def install
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

    pid = fork do
      exec bin/"forgejo", "web", "--port", port.to_s, "--install-port", port.to_s
    end
    sleep 5
    sleep 10 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s http://localhost:#{port}/api/settings/api")
    assert_match "Go to default page", output

    output = shell_output("curl -s http://localhost:#{port}/")
    assert_match "Installation - Forgejo: Beyond coding. We Forge.", output

    assert_match version.to_s, shell_output("#{bin}/forgejo -v")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
