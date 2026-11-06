class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/", browsed: "2026-10-12"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "96cd19cebdd9947e64d75e20c36ee956e432339640ac718ce885f7dfa7fd8db3"
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
    sha256 cellar: :any, arm64_golden_gate: "fdd0b24f1fd27aae3b87afb690026f9b20d1083eea2f3a87d5385385dacf2fda"
    sha256 cellar: :any, arm64_tahoe:       "cee9f12e3f183f790a12f03aa5fa4d920fc65fdd51df12a87c8bd2817587f5ae"
    sha256 cellar: :any, arm64_sequoia:     "f3b4999e4c63ff7f72e8384548a14db5f6f55e3eca3396ad2f9cc525644ff55e"
    sha256 cellar: :any, arm64_linux:       "f8293edf1557b812384f103b8851ffeff58288ce57cff88c593c03dece75ad1f"
    sha256 cellar: :any, x86_64_linux:      "9b6f77f83d4001a7903e18f7b89b399dd943ee658288ae26ad2ddda41fb2dc00"
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
