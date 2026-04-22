class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v15.0.0/forgejo-src-15.0.0.tar.gz"
  sha256 "deb9daa0aa72a95d44d871f5e79dfdb6ab080f83b47fc7f53965059429fc45ac"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "271545b243a078975d02ff87121506e870cda69d51c0ea94bc2ab891b412e7a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dc7ba992cc744fbc0acb399fcbf0fd1ffb284610d1840652cf3e0c961feb448"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80a0ae4e0bd2892d911858f94dee74291ed394f24b857b94401a2f7021a4796f"
    sha256 cellar: :any_skip_relocation, sonoma:        "92467f5e19250b6305351a25606710cada704042dc54e77f07adeaba987e266e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef84b3ae7d03f7069b850368ade4b46b3bb8f1c36e4b2378f9bca0f989184fe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17ec1a7999d1f4ac314d47116de7c8eea88d67355a39ff8e08cbe5684103a2c7"
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
