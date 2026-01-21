class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "afe1aca9f6e7680a95652e8acf84aef4a74bcefe558b5b91270876066fff3019"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96477b5cb46b774891a667e4536e391ac2fa8f60ac99fe120662829f46510fda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96477b5cb46b774891a667e4536e391ac2fa8f60ac99fe120662829f46510fda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96477b5cb46b774891a667e4536e391ac2fa8f60ac99fe120662829f46510fda"
    sha256 cellar: :any_skip_relocation, sonoma:        "1551e9b1712b6d9d66ba3371b6063a4987a259f0ab218d36db3497fe4b101fb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c96c63808ed662754e721edea9728bbae327d61585092922af70949c77b6555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94b31be97430571550fa2062de1cd6759d487ff92953c40624c51925b1873067"
  end

  depends_on "go" => :build

  def install
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
