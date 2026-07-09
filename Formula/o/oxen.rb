class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.51.2.tar.gz"
  sha256 "a4f6378bd938e37800e3d20ffe8d8d0b81d6f75cca1169f6997c6f3b9e1576ed"
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
    sha256 cellar: :any, arm64_tahoe:   "2188cfee49749f0c64dc761883c63c05d75492b6620d7c34532da98c1a7aacbc"
    sha256 cellar: :any, arm64_sequoia: "648f7bade9630b85826a923d816c48399efa13515e3208e9607f5f0a6d0412ff"
    sha256 cellar: :any, arm64_sonoma:  "f0e784f9b2845ea4433b94cbe94db504c24e13c3b79d4b334186b3cdc025409b"
    sha256 cellar: :any, sonoma:        "0c694baa35882b2a5bc3be736b11d6a1073d37d2a0dc5ce9d987a8184c180b99"
    sha256 cellar: :any, arm64_linux:   "e70199cb4fd3eaf86939a1f704abf47614e197c964d5eca9da4d124d63b954c4"
    sha256 cellar: :any, x86_64_linux:  "1ddcc8695750e7f99c350130bfb9db9e70fbe185a8b4493229ecb80ec9015c3d"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "rust" => :build
  depends_on "rocksdb"

  uses_from_macos "llvm" => :build # for libclang

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
