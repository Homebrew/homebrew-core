class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.7.3/pup_2.7.3_source.tar.gz"
  sha256 "1429a923173c03a4e0f9199fa4d3f431046a736cdd27eb154ec129c361766e06"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    manifest_sha256 "51903f0ecb0e82cbcba4363ce32b24efdac8bd4e489750e84211ce0171802e5d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0862be687d9cd5fa307057122f0519aa3a3d1ef98e0c3516eebb98a5e8607a1e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f5577b3988c334359ff9811e7d3227c8028d8bc8e13e2a20da8e7c50f1f8d32a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ceda9bdd79d0e94c48994e0272aead236af9ca6f85879d79dc87237df7e8c985"
    sha256 cellar: :any,                 arm64_linux:       "4b27789c4827e81c7ca43c1bf6ab7fb9f19d9803a5e0c9d4361042c7733d1779"
    sha256 cellar: :any,                 x86_64_linux:      "0be2f126f46a97e88f1d1451442776af117de850603bb64fc2fe5f604829a263"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
