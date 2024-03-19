class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.55.1",
      revision: "a5b7abfc8b24491a60fb72369b9e980791f63dd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73fc06a9634598d87e76c98ad20e4b22d6d3ef677c64c45e2296f629529b25e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73fc06a9634598d87e76c98ad20e4b22d6d3ef677c64c45e2296f629529b25e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73fc06a9634598d87e76c98ad20e4b22d6d3ef677c64c45e2296f629529b25e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a67a00fd2dc3014e8ff9eaace140bbc09b5e24607c8044b8d7d58433c86a93d"
    sha256 cellar: :any_skip_relocation, ventura:        "2a67a00fd2dc3014e8ff9eaace140bbc09b5e24607c8044b8d7d58433c86a93d"
    sha256 cellar: :any_skip_relocation, monterey:       "2a67a00fd2dc3014e8ff9eaace140bbc09b5e24607c8044b8d7d58433c86a93d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cedd09d22ffcbe0154290eacd093f1ca6e5bc28f5b546bba1129a0d7b7e1038a"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.toml" => "frp/frps.toml"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.toml"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end
