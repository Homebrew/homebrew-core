class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v15.0.3/forgejo-src-15.0.3.tar.gz"
  sha256 "39ac3023d1d6165a87d89bb44402ec4567327d952900d5522b92a3951b45db45"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4722726e87f7bba5fc403dd9743680ddcc69ed76d2a702d2befdd91daa74ace2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcc800b9e4b385baa8b83165540dd49fee4ba871e3734c196a26160315e4e66b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d913e1e31ac4ab4d2457d9484d895d876b1e883aa34bb1f8f4f28f05a1670903"
    sha256 cellar: :any_skip_relocation, sonoma:        "17bf3764a9b4f3b4146181e8712c5e7945174293430b147f82e5979d8803a7b6"
    sha256 cellar: :any,                 arm64_linux:   "7f86f05219ed0afb2547b680d740807b8328de73ca55ee0468af700cbc81f78a"
    sha256 cellar: :any,                 x86_64_linux:  "da14a700e96c188bc1745ccd48a18f96c687ca9675db297bb887c3324471984f"
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
