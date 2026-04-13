class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v14.0.4/forgejo-src-14.0.4.tar.gz"
  sha256 "34326eb230015f12f2a6610b0f4559447e62b4730b3d2607c31342ec8fb65556"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b65263078b5901f0142858f4afbad7f3e05c70ba99f96ed1ce7a37d22ec6f77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a940c2a10e633805e8b952157ec2a39e8dd8196cc0bf3c3bd83429cfb14136e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0688a1af1a16ffcb067ddd478ce2400404b24ace6dab1a65eb93586b3b89317b"
    sha256 cellar: :any_skip_relocation, sonoma:        "115b0d4e4ec47c823b842b4097d5defb7615bc40c818f463744ee8dbb843400e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "150afc6da5c87005ad4f9c2bef410200d85dfbed3ec43c88790c4e6dea45b4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bfd9fcaf9d87517ecc94886f2defbdcf01198df5348eec87451b69d3b6fcf13"
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
