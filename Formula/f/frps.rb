class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.58.0",
      revision: "4e8e9e1decf37294cb2ab576158b5ecd4ffdbbf1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8a46ebd04192239155c2e173190403573b830a4ae781375d5221d02ec4407d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8a46ebd04192239155c2e173190403573b830a4ae781375d5221d02ec4407d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8a46ebd04192239155c2e173190403573b830a4ae781375d5221d02ec4407d0"
    sha256 cellar: :any_skip_relocation, sonoma:         "de15440287eababb0dd91a398cb8779007aadacc75e7cca8f3b2badc94a988a8"
    sha256 cellar: :any_skip_relocation, ventura:        "de15440287eababb0dd91a398cb8779007aadacc75e7cca8f3b2badc94a988a8"
    sha256 cellar: :any_skip_relocation, monterey:       "de15440287eababb0dd91a398cb8779007aadacc75e7cca8f3b2badc94a988a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a983a2164bfedf50580065a01a7fe108dfffa58b3973d21f3f08e25085a13adf"
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
