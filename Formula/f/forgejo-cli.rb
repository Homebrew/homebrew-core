class ForgejoCli < Formula
  desc "CLI tool for interacting with Forgejo"
  homepage "https://codeberg.org/forgejo-contrib/forgejo-cli"
  url "https://static.crates.io/crates/forgejo-cli/forgejo-cli-0.7.0.crate"
  sha256 "a5c2eb931ed0c208ee432601850968158fbb1963a57313192db881e082060c46"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://codeberg.org/forgejo-contrib/forgejo-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3020dc89ba5936253fd1f99e907cce48ee6162afb7642ff40534dc3fc96525c2"
    sha256 cellar: :any, arm64_tahoe:       "9b2f0e4fc3154f3ab676a6c2c1aa77a76a0adbf382f97eaebd8f0d6719f80bf0"
    sha256 cellar: :any, arm64_sequoia:     "9b58e439afaf3d683beb4b4c8555d4f6abc96bd200aadd03ad3adc0b2788dda8"
    sha256 cellar: :any, arm64_linux:       "a4d5178dbceababe1a25bd6322f1d236edb5b60ec7c63646e5e1eef899e29209"
    sha256 cellar: :any, x86_64_linux:      "e27d590e5a4b8d077ba572fcf92e644b0253e9aab90c1fac1637a837da757ae1"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"fj", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fj version")

    assert_match "Beyond coding. We forge.", shell_output("#{bin}/fj repo view codeberg.org/forgejo/forgejo")
  end
end
