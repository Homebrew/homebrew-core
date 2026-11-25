class Garage < Formula
  desc "S3 object store so reliable you can run it outside datacenters"
  homepage "https://garagehq.deuxfleurs.fr/"
  url "https://git.deuxfleurs.fr/Deuxfleurs/garage/archive/v2.6.0.tar.gz"
  sha256 "cbe5d9fc04fe8e8d24c15c399edfb08b550b49beaa86577af4d9b55f3ef46cea"
  license "AGPL-3.0-or-later"
  head "https://git.deuxfleurs.fr/Deuxfleurs/garage.git", branch: "main-v2"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "a6041f638886b70612fda0e72ab9f386ed9c6123f89fcb1eb5ade534baee31c5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23d7e2b77e95e01e0ec4d81e7da607eebca90575b1ba26cc43454b30cbca7819"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f504466cc760defa0c59afbaa26fa73480153e9f7139cd1e3c45e617f04adf14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9fa1da623257748d80ed8f7be2656f9f6f08115f94a46051634ba257374bd6b6"
    sha256 cellar: :any,                 arm64_linux:       "548f69883ac48ace9c99de372e8dbdb48199aae893ec4c47072a1bedb9429450"
    sha256 cellar: :any,                 x86_64_linux:      "6ef1f8b1272648c7c5c24b09c4e6e5a89320985c8c1fa2eba6927bb09a51a4ad"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
