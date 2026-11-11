class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v2.4.4/pup_2.4.4_source.tar.gz"
  sha256 "3037e3e48d023dcc256597dd180033b945c8f17018cff94f3e1b5599601edfee"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "59b728b03d3afbdff5861145be1c40c24295e1e6e0d1bbf371a08a4d495519ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ad0bc49e0736f54354d5cbbfc82f4c4cfbfbe9c871f51bf3e775015efa8cf68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "22052218ec932813b75969a88830879e86573ba12acde5b649d4188f8447dad5"
    sha256 cellar: :any,                 arm64_linux:       "fe9a56e8b7364f84b85728055aaf3e0ca4ffb16265445be23ba628700cca7ca6"
    sha256 cellar: :any,                 x86_64_linux:      "79416472b12a7de09c788696893a1f6facd692f23ec1bbef42eea9be94c0e6bc"
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
