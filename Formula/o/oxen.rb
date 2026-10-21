class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/", browsed: "2026-10-12"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "bc6db9cfbff59e83559f79fed4cff7f3d405175bf641b60f30de4c76a2063baf"
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
    sha256 cellar: :any, arm64_golden_gate: "64df11dfd0e675f58872c017571107a1c7e1b5fb4ff1fe17e2f6a9904c683d27"
    sha256 cellar: :any, arm64_tahoe:       "02bb20724d6355fcfc9b5982a1e1e07594973d3a7bdf00dd423fba6930eb351d"
    sha256 cellar: :any, arm64_sequoia:     "f3212a2f26ec0da0a4e4f2896fb7cc564ba7bd83c95dd0d0ee810fe0ac8c901b"
    sha256 cellar: :any, arm64_linux:       "6ab65a14b012d240e8d8903fe9e50149b6a10cb56827f992d326bcbe82ee0ff4"
    sha256 cellar: :any, x86_64_linux:      "34cb4eb69e4c487955e89808806eba65d7837ff37df5f176854855117e49a17b"
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
