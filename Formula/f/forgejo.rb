class Forgejo < Formula
  desc "Self-hosted lightweight software forge"
  homepage "https://forgejo.org/"
  url "https://codeberg.org/forgejo/forgejo/releases/download/v14.0.3/forgejo-src-14.0.3.tar.gz"
  sha256 "98410f3f2aa26d3b1e25f509a78854315f8b5a99b9f7b1c9d60f04db2c65c8c8"
  license "GPL-3.0-or-later"
  head "https://codeberg.org/forgejo/forgejo.git", branch: "forgejo"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67354a7f9ec7e74a1959a33695c5465581fd65d80246473a7009961615d1d129"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07377e65532481ec7ecac0d14706fad5743b8262251378634c3158f10863b2cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2f47458a31785b237ba1eb0e5e7378d344c467e0899bdecebc938b6b934c4ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "8789ef9c43fda63814b0ffcfd103a8e4a2241c8add3b5f6bd6fbca567affa9ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "376d3a24010030ef00892cafa477e4df59438d8533c7c539b38b2672c06b0ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b24cb9bfa3e571708fb1582cb376dc15b3e087747427549205325dcb31629f5"
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
