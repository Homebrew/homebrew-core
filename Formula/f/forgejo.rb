class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v14.0.0/forgejo-src-14.0.0.tar.gz"
  sha256 "b15b367b4c30d8d2aa275618bedb5e34ad8fa604d20f4dc1804a949803a32dba"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f2eaa8ab9eb2d4002706ef147fb6e8697c7152275159a93dcea69ac67141461"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f68ffe503eaec28543ebd53ac81652fb994cd384a81d6bdf384508dba851a553"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa0678f48919a43a9dacc9153e9ee3a00854fbc71ced0a6ea9cc3394317623b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7deff9b8e4286378aff905b99d6328b8299f70fa6f8444eaf6941f42922fc15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2aaffb8577f20a1013f4b7a8285bc54ba7d44dd1aa5147f52605ffd924d7d03e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1af996e54687d565aed022b95d7a943a4fc9ea4f59bf51f677ca4a3d9ebbbc7"
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
