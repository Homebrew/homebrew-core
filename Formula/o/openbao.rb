class Openbao < Formula
  desc "Provides a software solution to manage, store, and distribute sensitive data"
  homepage "https://openbao.org/"
  url "https://github.com/openbao/openbao.git",
      tag:      "v2.0.0",
      revision: "700fe3f27ab1f0ec39ce20c36f6d9d97c9fe6ac3"
  license "MPL-2.0"
  head "https://github.com/openbao/openbao.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af464d4037f1acd7124f137cf5c7be313a28f95769b7792ea585e13ee387e0eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "727429756f2a735ee3e42a7ecf49211b74f2ba8d32c0af44699de955204a962f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c42862fba3121ac5de907d2935032f05447195b0abf4e15b462a45dcad528c35"
    sha256 cellar: :any_skip_relocation, sonoma:         "103207b89a4162534689ba8c724bd83fffb3ef8a43c93f36ed281a74d79d77fb"
    sha256 cellar: :any_skip_relocation, ventura:        "3b4e7b097203817485e80bcf0290a09337998c705263643d2588ae70e0ba182e"
    sha256 cellar: :any_skip_relocation, monterey:       "4c38002cf17fb848093cc843243b1d974eee13c1a73c6637951f1b3e3122ca85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fb2164b465bc22ff6eefaca0f84b67107ece5e38288baac9847b43704d5da86"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "curl" => :test

  conflicts_with "bao", because: "both install `bao` binaries"

  def install
    ENV.prepend_path "PATH", Formula["node"].opt_libexec/"bin" # for npm
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

    pid = fork { exec bin/"bao", "server", "-dev" }
    sleep 5
    system bin/"bao", "status"
    # Check the ui was properly embedded
    assert_match "User-agent", shell_output("curl #{addr}/robots.txt")
    Process.kill("TERM", pid)
  end
end
