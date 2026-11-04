class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/", browsed: "2026-10-12"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "6d3a1ac03717a3e0a93c50bde2faa8e016f7aab56adf2d1f61881b191f52a8e2"
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
    sha256 cellar: :any, arm64_golden_gate: "fd79686b9ced97c481063190b3e3ddb3151e2aaf774f8430ce8493c965d11922"
    sha256 cellar: :any, arm64_tahoe:       "9bfe7d76e96b92a8d8c07c9d4ed4f03e0fd4e29e84e75db29800130b3e4ea163"
    sha256 cellar: :any, arm64_sequoia:     "12f38484f874f2e28c38754d9611d7a05117e9b9fb757c5d97699e002c1303d8"
    sha256 cellar: :any, arm64_linux:       "c6a09714f5f8d6b3a11ff0c5f001f33fba456be421983f98ba8384a946f4d9ae"
    sha256 cellar: :any, x86_64_linux:      "2c8c75658f420b0c1467e0f3eef7ee7475082bb5426f9c84670123fd0498e8c5"
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
