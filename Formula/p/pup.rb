class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.7.2/pup_2.7.2_source.tar.gz"
  sha256 "e8a3c2ddb910a95be2a6343e669cf0785788c2e8a0c5d5b6b8401e91ba04a6db"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    manifest_sha256 "117c3617739fc7262ca61298bce1d664a62cd7b22224f5a0901481a14ee0ef51"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "adaf7936ca4af8b6b378a38de51d33d9f5efcc2163145b478462f907a1e95550"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3560993aeab1a48eecfb548e3a503f746d157db84c1e6dfde373194cb3164194"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2d385fd3227db3772a29edbe4b0a172e2c042ff9fd2279180220b0740f54975"
    sha256 cellar: :any,                 arm64_linux:       "1a62026afd24e104bf1832552045595bbf1efea42e1853aa36d72e88b7f8e2ae"
    sha256 cellar: :any,                 x86_64_linux:      "31cd436d1391251cd755b335210b15ae659730ac8b9253d630f439ec8f5b8797"
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
