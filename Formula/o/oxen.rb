class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/", browsed: "2026-10-12"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.67.1.tar.gz"
  sha256 "d7ceb9a876b80f903c5afaacd8e4f21905dd57646483e082aaa0359a36eeeb57"
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
    sha256 cellar: :any, arm64_golden_gate: "135acc3cb08aa3985e6d9522fcd34e312be5dd473e0c58448c78b898fa3d9dd5"
    sha256 cellar: :any, arm64_tahoe:       "b7ade255ed34d52f40a9e9541ef371fccb01b9987551a68561c1870696edd6a9"
    sha256 cellar: :any, arm64_sequoia:     "036b91192e79b6222ebe9498529a664609cc7a14b45a37005b4dbb68fca8a801"
    sha256 cellar: :any, arm64_linux:       "3154904d9a511a1a03b4e49b1d11d018a6fd16d9b6687613faa89442afba2d12"
    sha256 cellar: :any, x86_64_linux:      "9a7d7729a3f520a59add2a5f30b648ec99da88d2fcb6db93ba122805652eb25d"
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
