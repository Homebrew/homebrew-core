class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.34.1",
      revision: "a5d0f122705cc0981419fee4eec51aa18b69a9c1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7879ff7d5c62e68edc8ec38cd30a2ddbe12b0e27de4b92ef2daaaafd1d246fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "495c18f07615f81c43c1280145225375d1afc73e8281e22bf4d49485fe9ef964"
    sha256 cellar: :any_skip_relocation, monterey:       "6f39bfaf0b5688f996f4de3612c9f499a040e0290fda9ae83a5d5a1bc6b86bb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "16da8ab8102ede99b5d1a944ac458baa5737e897b2fab9542125276ffb978158"
    sha256 cellar: :any_skip_relocation, catalina:       "059559ff6d4ecec3eda666131da5fcdbb758cec48c1b79bd2beeef931a4a73c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea444474cfa363c543982045efa95f7df3a30860081b2c9ab88ecb4d5fbee05"
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
