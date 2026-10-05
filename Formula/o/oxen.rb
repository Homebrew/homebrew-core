class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "f02b9e54edc04b53b9ef2846812cdbe5d67aed61eaa67b5c88a81de43e778f3c"
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
    sha256 cellar: :any, arm64_golden_gate: "54ede80b8c8147b3f8b802818c2541b11175b5a5b47342cd8e23411ed2eb7831"
    sha256 cellar: :any, arm64_tahoe:       "178515d425ab1652a0d777fb5d59a3d08d4e6f2ad12b6422f99a643ed594050f"
    sha256 cellar: :any, arm64_sequoia:     "44291a389840273ebb14f769c296b5b10d39a32d55e27a815d8b5711802bae0a"
    sha256 cellar: :any, arm64_linux:       "93bd49f55e40fdf2971e29760653a6bc89aceca6cd3bebe41fb7a25e99492bd4"
    sha256 cellar: :any, x86_64_linux:      "254235c9efd246cff4acbf45a9dfcd055971db77ddc938fda25eb848ba9fa566"
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
