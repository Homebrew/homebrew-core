class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.4.3",
      revision: "ef854342df72dba6ecfbdd3f130e251941ba7dca"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d503a63eb0fce09c3822530324d927bc74cbb741b7d21099154c976d3324d44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91466581df649b4e77a96e3665b9ce0cddb82626546603d89a16d07b37fc175b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40a2e198219ca8f07e7a4553d187a0687dc6fcaabfeb743b0ea857967d6b9e29"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca4e35b5fe484d3ec95616395b15bfc0a40da8211ac638cd4ffe2addc9ca6ea3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "609fd5c07f9c5438bb6b9a19e3bbc2269c911569a594f03d0388a3bd52d806bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b30fcf4ee7808fced7d4aa436ec001b9833ce6f3abda677601a803d97935b85"
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
