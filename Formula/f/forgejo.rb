class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v12.0.4/forgejo-src-12.0.4.tar.gz"
  sha256 "b1adeec3f5f446c63996250a334be62baf0cd8fbb9ad71a3316a5896cb327d08"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "258180711852a3001209d000563e6a702d6733d736c6a44756546ead2d034fe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90ebd8eedd67b3363bbc448aa3b84e647a4279bcabfd515d207f25d19cf2d6c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c46246692d956048417ea4abee26db022e5e075d980b7d5f785c0ff267e701d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "37a86215cde465009fa7d99a3aa638ecd3ff2ea4d29c248ead130a15524df065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0228b39fb26c4cc7017bb5f1de36cba8d45d50d283c5d0b934993c5a8c6d186b"
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
