class HelixDb < Formula
  desc "Open-source graph-vector database built from scratch in Rust"
  homepage "https://helix-db.com"
  url "https://github.com/HelixDB/helix-db/archive/refs/tags/v3.0.8.tar.gz"
  sha256 "05fd2888856c4238b05eb50e76f529b3da2cc8b4fbecdcbcd0a9d9b294cdb71f"
  license "Apache-2.0"

  bottle do
    sha256 arm64_tahoe:   "656d971db26191ab1086e520707659af227a3f996081fd3ff354d50bd4ad2efa"
    sha256 arm64_sequoia: "fdc2b78d55dd4eadb69bbb7d9eff0e3c4d0502c001954594ae7cfd077ed4b264"
    sha256 arm64_sonoma:  "056112c97961c597dbf6877a977ae2e32844579b788cae1643e6030ee9bec055"
    sha256 sonoma:        "1352058ca71139210330db71e339b41943452384a476cda5356a137f73f7e2ea"
    sha256 arm64_linux:   "eeccd33657a626ee36685dcff4dd2c24f9bce1023d3329e302a4c39eeefe36d4"
    sha256 x86_64_linux:  "389ac60167f1228aeb6c959ee26de97d40244004b5c6ef06881c7a7718f73bd4"
  end

  depends_on "rust"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "helix-cli")
  end

  test do
    project = testpath.to_s.split("/").last
    assert_match "Initialized '#{project}' successfully", shell_output("#{bin}/helix init")

    assert_path_exists testpath/"helix.toml"

    assert_match "Added 'test' successfully", shell_output("#{bin}/helix add local --name test 2>&1")
    assert_match "already exists in helix.toml", shell_output("#{bin}/helix add local --name test 2>&1", 1)

    assert_match "helix.toml already exists in #{testpath}", shell_output("#{bin}/helix init 2>&1", 1)
  end
end
