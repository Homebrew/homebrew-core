class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.24.tar.gz"
  sha256 "0508470ea01156ef7e275d97f12ceadc99d952897d4cb7454f790b15bfe31d0e"
  license "Apache-2.0"
  head "https://github.com/aiken-lang/aiken.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "88e769286eeb71f3346f50144b443bcc776e594e3dd52ebd0f0f08186f3f3a7d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cbc54fab505addc057725bd0d8a9c22a70a1abd3b8a8ab1d90d13c4fc3369ca4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "923e0452295efde67f4e9da44f915dee9c276a7d2735427f76cbd4642b8196ea"
    sha256 cellar: :any,                 arm64_linux:       "b74df01b8dca091b975db4e6c4b5e2050db76efbc07814316a4a6dea98646ebb"
    sha256 cellar: :any,                 x86_64_linux:      "9a360a0c0a6fa3c6e7be5fafb6ca1874586f2cdff0523ae4b90fb615969de3ae"
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
    system "cargo", "install", *std_cargo_args(path: "crates/aiken")

    generate_completions_from_executable(bin/"aiken", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aiken --version")

    system bin/"aiken", "new", "brewtest/hello"
    assert_path_exists testpath/"hello/README.md"
    assert_match "brewtest/hello", (testpath/"hello/aiken.toml").read
  end
end
