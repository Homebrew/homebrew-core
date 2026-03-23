class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "67cbc3a23c90bf730655f9a5f5d37c8bc1c3c866e1ff59788b859d407f5fd00e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbcdfe904f518270fbabb2bdfdecde2c6fa99809fe23773ac44e246f6cce1e00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "717d1f212515fb25d85e5c932d3cac33dfe865b99906308eaa546bd03da4de7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf206cae7840f978b17bc9144f5cbc36fae0d4782dc655abc525c4e2a9906b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6aae4c4c242fcc5db1f1dc8674a05c6f3b65f8a092bacbaee198a7f835b9b5ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "626eeaf2511a2e75aae2765e4a08d68730f11c04f333b8cd6a17a51f73309d27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00eef41aeacd92837b37a91ce79241a836e681a6dcc8f0ff8b2b88b299f3302c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  # https://github.com/stepchowfun/docuum#configuring-your-operating-system-to-run-the-binary-as-a-daemon
  service do
    run opt_bin/"docuum"
    keep_alive true
    log_path var/"log/docuum.log"
    error_log_path var/"log/docuum.log"
    environment_variables PATH: "#{std_service_path_env}:/usr/local/bin"
  end

  test do
    started_successfully = false

    Open3.popen3({ "NO_COLOR" => "true" }, bin/"docuum") do |_, _, stderr, wait_thread|
      stderr.each_line do |line|
        if line.include?("Performing an initial vacuum on startup…")
          Process.kill("TERM", wait_thread.pid)
          started_successfully = true
        end
      end
    end

    assert(started_successfully, "Docuum did not start successfully.")
  end
end
