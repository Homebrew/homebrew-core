class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/", browsed: "2026-10-12"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.68.1.tar.gz"
  sha256 "314482613f34f13e49376034be739ef2f1ef9a968cdf087fa6fe6d8feb6abfc5"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    manifest_sha256 "e4d5fea0ef1b5ba88651c7e97dd68474e0d3c6b8490ff8588a052be2e9e6d60f"
    sha256 cellar: :any, arm64_golden_gate: "ce2c14c312ae2cc992b657c737671036dd8883c3a7f30d99356412c3ae52e2ea"
    sha256 cellar: :any, arm64_tahoe:       "7b4bdc98e770e492bf630cdbf9ed27bee71eaca79d34790f5be0d534dee9f46a"
    sha256 cellar: :any, arm64_sequoia:     "71d2b1c532df4b77406068e496e1089975448792de15851e12243837f9107156"
    sha256 cellar: :any, arm64_linux:       "8b2497a54f1047e396bb3481f10c2419718abb9f0d92a5d7a07896da999f335f"
    sha256 cellar: :any, x86_64_linux:      "12af78dce339e77b30ec2923e723e1a722b0f5135f0c4578b49f7ae005566368"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "rust" => :build
  depends_on "rocksdb"

  uses_from_macos "llvm" => :build # for libclang

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["ROCKSDB_LIB_DIR"] = formula_opt_lib("rocksdb")
    system "cargo", "install", *std_cargo_args(path: "crates/oxen-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
