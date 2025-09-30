class Modsurfer < Formula
  desc "Validate, audit and investigate WebAssembly binaries"
  homepage "https://dylibso.com/products/modsurfer/"
  url "https://github.com/dylibso/modsurfer/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "2f5defcfe8668d7323a83dab0b323282e2855a4171c1d0d4eacf5963aa3729b1"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "771be4aaa710c9ab747d8c99f16be41f132e0f0662cc59c5e5ef1b4827fcbbe2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4de08833308339b9707922798aeede8757c81d4e025667d2290b183aa2c161e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42474789dbb88caadbcf8c0d113545c1bf40036b77cc89a88368e28413c97886"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7720cac93edc2ab0f29464ba3bc195cca1f5cc1e1d2ad6f9d98303b6b98f46ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34b454f9d922b88adea055d86ea1ecbf08943162f0b69c73c03da9c664020bbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "b917744c1619ac05cdf12c8236ed2d8f6e25078bd7369c701ff9a0a0ef041303"
    sha256 cellar: :any_skip_relocation, ventura:        "9f033931b5c7fbf412ec53091fb423d5c376f509abe0a472fc2a6e52c320968e"
    sha256 cellar: :any_skip_relocation, monterey:       "0e987ef1c06a80190898850d0aaa1e26d9c3515492f8ddbcef4a6c1a7af6dde2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "12a645180f3f4fa5735a85750d323b060dd085e408d0f0d5aee652ea07dcc845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ae0a282777800dcabb713ce0f994bf1cb0d4154edd5bcf2cdaec083d05b2dd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/modsurfer -V")

    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)

    system bin/"modsurfer", "generate", "-p", "sum.wasm", "-o", "mod.yaml"
    assert_path_exists testpath/"mod.yaml"
    system bin/"modsurfer", "validate", "-p", "sum.wasm", "-c", "mod.yaml"
  end
end
