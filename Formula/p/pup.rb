class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://www.datadoghq.com"
  url "https://github.com/DataDog/pup/releases/download/v1.22.1/pup_1.22.1_source.tar.gz"
  sha256 "678ef18627a754fad5b8bb7d58e873cd1d70afb5ca25f3002a777fa73b56a4fb"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9604711f892f537f342139b5579e79d4736eb07f76025e97a3dfba1b1017ce36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dc22f8c648c7c7e9736e40e5c5c7cbc8725a38b708453fc2b66ce0ebb931c60a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "92bdff47600dc362940b3a8624545c7b996ddb060388ecf91fa648754418b6cb"
    sha256 cellar: :any,                 arm64_linux:       "7a49587a0cdd14ebf231c32b535e4afc9e370d06cfeda7dece02abf645804bfa"
    sha256 cellar: :any,                 x86_64_linux:      "9b978bfaf9217c1a1b144bcbcc4e33b6c1d268d15ab89bd78702c8073bff2092"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
