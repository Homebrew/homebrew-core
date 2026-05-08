class Proxelar < Formula
  desc "Man-in-the-Middle proxy for HTTP/HTTPS traffic"
  homepage "https://github.com/emanuele-em/proxelar"
  url "https://github.com/emanuele-em/proxelar/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "b35856253e6d8e5bfdeb7646a24cf23dadda1b3a6e3d05ef49e4c9d15d20ee3c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21df062661223523cd577320798783ceba457c7a5996123fbd99cbd2a0984d50"
    sha256 cellar: :any,                 arm64_sequoia: "81334fb5fdcd8a38b1d1c0c143d0ed2fcdf8fdcee15e64e5ea76c0cb85d555b4"
    sha256 cellar: :any,                 arm64_sonoma:  "1229b6ba3ae4fbc21e156bb596da64aba71442e5fa3511d0bcbde1f2dac758f1"
    sha256 cellar: :any,                 sonoma:        "9244496614fb29c7f4b36275aaef3abd85dc0aab0e3b28015714c77c04be3a6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0209ea64efa49f499c575ab5ea268c2e11018649ca063a3eed8e6c3c9bd7e57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31482d2c17cd06c5bee69e2a2966cc01412813413eda1587a10af42f71cf7b3b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args(path: "proxelar-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxelar --version")

    port = free_port
    pid = spawn bin/"proxelar", "--interface", "terminal", "--port", port.to_s, "--ca-dir", testpath
    sleep 2
    begin
      output = shell_output("curl --silent --max-time 5 --proxy http://127.0.0.1:#{port} http://example.com/")
      assert_match "Example Domain", output
    ensure
      Process.kill("SIGTERM", pid)
      Process.wait(pid)
    end
  end
end
