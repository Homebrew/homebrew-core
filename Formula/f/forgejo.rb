class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v15.0.2/forgejo-src-15.0.2.tar.gz"
  sha256 "c52a7df751de7426657bc06df336248e05fb663bcc9205e870557ce6a020a199"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ac96dff5de4d8c2c973295e65e349628fe2e6f12e5b24411df50bb4bb1fed5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3f4531281a3a7705e6ee59496f47b7faa0323b2b17bde46f3d9fb4e0a795fea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "151261081c94c1d828658598d377c683ef9ebf425ddee4d900233fcd8a194f7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7b2c3f2ef779256bbd7208adbb548ee9903e33c57e642eb4358d95c6ec22d30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e51011a75b15783764e62790795d2fe924502afc68aeb52796a37bf0b72d7a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0c46c6067fb2cf85d17fcdecf01855b6ccc6e462af1613f47e1c2d297332220"
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
