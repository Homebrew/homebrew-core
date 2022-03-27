class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.24.0",
      revision: "fb00657cd46406b6660f5fc1fa4894d6c426d295"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1526cc14a0c0094374633c4d51c8dabf001c4dae4f77f4700f985cfdcf221413"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f039d647c2afe7ce2085a380abbf585e2c40237ad93636289f7072bfa60c5b28"
    sha256 cellar: :any_skip_relocation, monterey:       "bd103ffbd6966ad02ecaf82de647b087a90ba9e05c35f4832a7546622745b325"
    sha256 cellar: :any_skip_relocation, big_sur:        "712cfb387a3a1a54b75b6eb16e56a0177555aebe845e97e22fac65f3104b2b56"
    sha256 cellar: :any_skip_relocation, catalina:       "ef655a3742da4c75e3486768f1fd308fcd2a68e5acd1373486fd7b437679296f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0177066fd9682d7ebd9e610454b5348a54035becde5a3924f1f4fd3b570cd746"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
