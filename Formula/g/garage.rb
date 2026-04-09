class Garage < Formula
  desc "S3 object store so reliable you can run it outside datacenters"
  homepage "https://garagehq.deuxfleurs.fr/"
  url "https://git.deuxfleurs.fr/Deuxfleurs/garage/archive/v2.2.0.tar.gz"
  sha256 "e68b05d4358008e8b29a0ac235f73e3a12d97d9c6388c330b87282db774c04dc"
  license "AGPL-3.0-or-later"
  head "https://git.deuxfleurs.fr/Deuxfleurs/garage.git", branch: "main-v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaea47f576bc097b48ebc69ac3969fbe1384b50a6db452b898b41e0455436e40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4c22777b9e6848a776f2058a9905966bc696527a9c4395d069522d960d99e89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53b8c38aa92d1f51778217b4852b3171252eb3b8717260fc3ec5ebcf988a0360"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5cb293d845e1b4c2da8945b31f72c5ea0b6d7191ec58f923736abdf14b3cb10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fc38f9d7826707a74b5577e794d1b69ae3522f4b523cf0e4392310c9261885f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da02dc0dfd278772fd1d528b5474605f0981d40cd679cd3ae6ada4d662579c0f"
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
