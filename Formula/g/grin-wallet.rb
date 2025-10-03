class GrinWallet < Formula
  desc "Official wallet for the cryptocurrency Grin"
  homepage "https://grin.mw"
  url "https://github.com/mimblewimble/grin-wallet/archive/refs/tags/v5.3.3.tar.gz"
  sha256 "defe25b5e8e8c6f94a57792cd197e9d753710cb91a6e82dfc25177cea16bde24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a72f69bac55b83e42fa1262eb6dec2cb14026fd28c8bd68cf7b6170dc69761c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d54049d62d5a0b36292b2d21e5563848aac9d460780bd4bf454f7327e53a05d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "634ac3133c50339f68b98c0c3c2079af681802427a81ad7bd9ead796b06bd231"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4dfcada1df61633644eb26265f31587ed1476b2662f167c5952b36308633861"
    sha256 cellar: :any_skip_relocation, sonoma:        "edf969535683ee653d73a8ec8e3e7e5f5034d138afaeb1e73d7e6d002e1aa0fa"
    sha256 cellar: :any_skip_relocation, ventura:       "bcbcc92456ae39aa8503324872f30820719cfc5629252f5f6775aac15dac3032"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "533126a1a649000709dd1dc17796a482232e9b448f9f220985a3630d924ddfe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb8c9ea2d9d49a06a26ca2fd622921b83ae9144e496829f0c52d451a4fbe7286"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "yes | #{bin}/grin-wallet init"
    assert_path_exists testpath/".grin/main/wallet_data/wallet.seed"
  end
end
