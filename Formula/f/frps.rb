class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.62.1.tar.gz"
  sha256 "d0513f1c08f7a6b31f91ddeca64ccdec43726c20d20103de5220055daa04b903"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9807680d72d0c8d50be80a36b04827928aa0eeacc424931307b741a93b30522"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9807680d72d0c8d50be80a36b04827928aa0eeacc424931307b741a93b30522"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d9807680d72d0c8d50be80a36b04827928aa0eeacc424931307b741a93b30522"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9c83a1cdb2d1a589352522fa297418e4eedf86b25a29f20a12f386b52e20fed"
    sha256 cellar: :any_skip_relocation, ventura:       "f9c83a1cdb2d1a589352522fa297418e4eedf86b25a29f20a12f386b52e20fed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9827cf86b8f3040d5b552ed5dedc24d7d770db22bcf9ff0c5c3db08e0a205491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f80a9d6592bde266142dc3be2d572e8095635d6a641290ee10788e1f97a703a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags=frps", "./cmd/frps"

    (etc/"frp").install "conf/frps.toml"
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
