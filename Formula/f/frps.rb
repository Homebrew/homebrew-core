class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.70.1.tar.gz"
  sha256 "67246606f504cb15df72193f1a83911259e92b6a87838cff8850031efd406dc8"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2632df2ba4dbc1607fbca1e8ee97c6ffd9f7d9ff7f00963f5a7ec4dc2ee6c56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2632df2ba4dbc1607fbca1e8ee97c6ffd9f7d9ff7f00963f5a7ec4dc2ee6c56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2632df2ba4dbc1607fbca1e8ee97c6ffd9f7d9ff7f00963f5a7ec4dc2ee6c56"
    sha256 cellar: :any_skip_relocation, sonoma:        "433f2c1f063130472e340e07a7c4ef7f786bc25fa0d498c5a30181deec11e26d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ff69385dbc8936e964db1a39bc84ac013e83236c0ce7dc1834bd067ba055fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2205d5078a0a47cb21fd1253ccd56d6007f55f7b29ea7974ce5f6fbc3eee6e38"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web/frps" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frps"), "./cmd/frps"

    (etc/"frp").install "conf/frps.toml"

    generate_completions_from_executable(bin/"frps", "completion")
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
