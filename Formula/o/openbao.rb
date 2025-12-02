class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.4.4",
      revision: "4bfd70723d4f9b82be00e87b8c018ac661dd9b99"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f0e7c834e6dce0cf00128593516c0f600f8a5f63941ba5cdc5af4fac101f89e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a21513f1c682beba9555549dec65bb052c0b4911784985d2487e91b3c1d4dde1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa115e2a8cdbcc979ae939d874f169ab11c3290dc00715b9a3d12343ce0c1fcf"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbe4fe7600d30c316be5789116fd2f91299f0b3986613c6bdf3932801e81ba47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f06a3e8035b9f0f8288dbea4e4ef7115ae92ab4739fdb1b84fc2d173081730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16a548408a29fa19ae80ac8e81cb90c22f5589ad5888f80a02d960b51786bc55"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build # failed to build with node 23, https://github.com/openbao/openbao/issues/731
  depends_on "yarn" => :build

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    ENV.prepend_path "PATH", Formula["node@22"].opt_libexec/"bin" # for npm
    system "make", "bootstrap", "static-dist", "dev-ui"
    bin.install "bin/bao"
  end

  service do
    run [opt_bin/"bao", "server", "-dev"]
    keep_alive true
    working_dir var
    log_path var/"log/openbao.log"
    error_log_path var/"log/openbao.log"
  end

  test do
    addr = "127.0.0.1:#{free_port}"
    ENV["VAULT_DEV_LISTEN_ADDRESS"] = addr
    ENV["VAULT_ADDR"] = "http://#{addr}"

    pid = spawn bin/"bao", "server", "-dev"
    sleep 5
    system bin/"bao", "status"
    # Check the ui was properly embedded
    assert_match "User-agent", shell_output("curl #{addr}/robots.txt")
  ensure
    Process.kill("TERM", pid)
  end
end
