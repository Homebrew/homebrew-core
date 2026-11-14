class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/", browsed: "2026-10-12"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.67.2.tar.gz"
  sha256 "89ba6af9498c7c58ef7755d0b12330bfea8078a097dc72aaaf24f28180124220"
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
    sha256 cellar: :any, arm64_golden_gate: "a3a4ced7cf7f3b45718ef085aeffc35776d329fe53d4597f36cfd3a0fc2bd86a"
    sha256 cellar: :any, arm64_tahoe:       "cb3a3c72ddf1c5d33f78ae33a9d6b6eed478ee88149fc8feb9a39ae97ca69317"
    sha256 cellar: :any, arm64_sequoia:     "8cb98e6dc223abc90914d526bd205678bd9d0e8961d7f0791ff352e4e4d71784"
    sha256 cellar: :any, arm64_linux:       "1405479e84e66ad921e6292f9202fc5c0795d03e85b3748c21a1ee33c1d8287e"
    sha256 cellar: :any, x86_64_linux:      "6920eaea06d38cd38a5b8145a375677e9cb600d18a05ba155167f89eac37db1f"
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
