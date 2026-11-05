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
    sha256 cellar: :any, arm64_golden_gate: "ef22c0eb77cf2e11044e9f4d0c26a353e2ea3f35a2eb847bb7ba657758cddf7e"
    sha256 cellar: :any, arm64_tahoe:       "812a1242d36cbf2b713e81564be1b948f3c79dbdee50a56cbc798667866b9b34"
    sha256 cellar: :any, arm64_sequoia:     "eb6ad3c4617b3015d55f3a8c8ae3a1f45c81d54bd2fa09c9ffe9adb1ccf1301d"
    sha256 cellar: :any, arm64_linux:       "b7536b1aa9444a6bb15d6199ae125695ca98cc1cbe6dd93aef7391953039e0ab"
    sha256 cellar: :any, x86_64_linux:      "095bd69d5913328aa551193963f71b5aa96e7c5c4bba9b37a80c6ca42bc28f1c"
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
