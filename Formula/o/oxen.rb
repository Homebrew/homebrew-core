class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.57.0.tar.gz"
  sha256 "c382675e41930d7a8097a55c884a7f08832e9d8c36506432ac8df39dca3eed8c"
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
    sha256 cellar: :any, arm64_golden_gate: "b5b93604cf6e33c262e62a89aa6488c8e71a807ec1ec3eebc62dbc724ab21e39"
    sha256 cellar: :any, arm64_tahoe:       "2311a1bc580adf1997e879b7f9767f5c77a17b114eb3323d888e4baf565a02b8"
    sha256 cellar: :any, arm64_sequoia:     "b31cfaa0056dfe140d18e40621d818745c43a92e0b28cb0cec41795589af55f9"
    sha256 cellar: :any, arm64_linux:       "a7ce01e7a0f7c68b49c19fe6c3eb89f1ebb0f332270b701c8f0217d825bec215"
    sha256 cellar: :any, x86_64_linux:      "a8a15a2363436377fad385f8b78c3effe321776e6df0ef2dce26f75815dec396"
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
