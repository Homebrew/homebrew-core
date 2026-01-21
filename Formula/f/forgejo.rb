class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v14.0.1/forgejo-src-14.0.1.tar.gz"
  sha256 "375505d2155769f5b4b388c3550b2e7fa758e843f59d08bccf812beed548bf42"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95a0f474b56e8812857352b32ba210b26565390fa5ba7541e0dd7f8f0ed25431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ed442a08a7c3903657fffff8a84dc0e552a007683241b45648768209bf1d317"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bb357dd1e1aa9742a78cdb200fd27b513aec4aa84c60d8e9cf7d3a90a8bf627"
    sha256 cellar: :any_skip_relocation, sonoma:        "2779d1311efea7248ee46b5be675baca303fd0bba3f8fab340fddab6b6285ea3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62c44379e6e2317bc3f592606735f295bd77b5695270d483a4f93af5ceb99f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "328ad669a8d56432c838507d9bb6d998caada1870b6dabf8667b905173b89a64"
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
