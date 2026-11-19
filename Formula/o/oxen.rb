class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/", browsed: "2026-10-12"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "5d2fffe31016e474a8afd94951b6b4e2fc7ab4d14c07ce76d35209a7b623162c"
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
    sha256 cellar: :any, arm64_golden_gate: "a018fb9211e39bcb62065eefd7e7f76eea4137125dbfc19387e92f540660d6b7"
    sha256 cellar: :any, arm64_tahoe:       "c0879f1a5f2e05ca0d73155f3ab10f7267356a05373c63a760daaf332defe9c9"
    sha256 cellar: :any, arm64_sequoia:     "a0e0e3e778a38423df1b69af01fb49588a131e3eac1c338879c80e4b99055f22"
    sha256 cellar: :any, arm64_linux:       "89a5f01b429ae115cf12850910eb613078427e520ab2db6079edbbea9168df81"
    sha256 cellar: :any, x86_64_linux:      "ba4c5f5f521ffc7f7ec5bfe4a65125a1abd5c934e1bfaa1b915c2f335cef4b11"
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
