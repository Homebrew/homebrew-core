class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.61.2.tar.gz"
  sha256 "19600d944e05f7ed95bac53c18cbae6ce7eff859c62b434b0c315ca72acb1d3c"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acae3f5baff0ed1d9f898f5209af2c01257be02630a21021ee414517880992b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acae3f5baff0ed1d9f898f5209af2c01257be02630a21021ee414517880992b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acae3f5baff0ed1d9f898f5209af2c01257be02630a21021ee414517880992b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a03f632261a17cad43381e748f011e970198babf231f321d6cb87876097448a0"
    sha256 cellar: :any_skip_relocation, ventura:       "a03f632261a17cad43381e748f011e970198babf231f321d6cb87876097448a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fef9532938ba7fb29fd3fb12a692d18c3c6086e6ef96a711e62a0000e1e5c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df0a2758a2decd51087fdee5985d78bb64c96b47fe070c5b7180a8cad3847083"
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
