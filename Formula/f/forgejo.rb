class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v14.0.2/forgejo-src-14.0.2.tar.gz"
  sha256 "422f04bfa0f615e4d686cfae9012693f821eaaf7efae8eb4905416c5633440af"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44c47345ef6f7726bd6a3fd5bbb20bff6d71073d0c7f51e9ce6b17a51bfce371"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc34c91eded7639d4ace213f993de84e83f4db773bd7295297a6706e1cf5a1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2701d4b7363893d8c96d7472a5d802dc75c615655118ee352c140f884e0e5d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "df7d9c8a567e6fb709191fdfd2cffaaec55c5b735cdac5e760aed761372ec2a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f120653aead7feda5eb423de222f8164a010c2d444f46e4742a80e9da1f1c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9581e7de1727dcad367ccad4e66c6b5a3655c3f23f0f62e643a4361c0342de44"
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
