class Garage < Formula
  desc "S3 object store so reliable you can run it outside datacenters"
  homepage "https://garagehq.deuxfleurs.fr/"
  url "https://git.deuxfleurs.fr/Deuxfleurs/garage/archive/v2.4.1.tar.gz"
  sha256 "9149931f0e567a66cd96c33b6349e8f1900279ec6ae57c60bfd29d450104c553"
  license "AGPL-3.0-or-later"
  head "https://git.deuxfleurs.fr/Deuxfleurs/garage.git", branch: "main-v2"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a960407c0cc8fbb58cd23f32a225b282d80620c5799c001450a7a1ad718437f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "12bf8bdb0895706e0bef7f435d28b744e88d7aa443c21d2da81a06e9008fcfbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "97e03a93d459bd674adf22edf7e0f04d32d794e9a1b78a8b3b98d23d4037000b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "32c84f14cecc9b51640a91d598d0514b560e4f3349588fea8b690c78cced810c"
    sha256 cellar: :any,                 arm64_linux:       "612adee4790abf1af4678890164b2a66f7416ec33579f0ecdc5ceb36d6f69a32"
    sha256 cellar: :any,                 x86_64_linux:      "7d18525ba94590a8660a67d864e1b2520cdf6ac48adf8138c6e9331985744ffc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "src/garage")
  end

  service do
    run [opt_bin/"garage", "--config", etc/"garage/config.toml", "server"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/garage.log"
    error_log_path var/"log/garage.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/garage --version")

    rpc_port = free_port
    api_port = free_port

    (testpath/"garage.toml").write <<~TOML
      data_dir = "#{testpath}/data"
      metadata_dir = "#{testpath}/metadata"

      replication_factor = 1

      rpc_bind_addr = "[::]:#{rpc_port}"
      rpc_public_addr = "127.0.0.1:#{rpc_port}"
      rpc_secret = "bb2763a7c7c397d17eb9d604c063699ab5de605cee438b7f4288e6ff1695081d"
      [s3_api]
      s3_region = "garage"
      api_bind_addr = "[::]:#{api_port}"
      root_domain = ".s3.garage.localhost"
    TOML

    spawn bin/"garage", "--config", testpath/"garage.toml", "server"
    sleep 5
    assert_match "==== HEALTHY NODES ====", shell_output("#{bin}/garage -c #{testpath}/garage.toml status")
  end
end
