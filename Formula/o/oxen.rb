class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.53.4.tar.gz"
  sha256 "81ef2710f41c61fb8e417df4972f662e9defbc2524c0e68af2079c7743c3fef0"
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
    sha256 cellar: :any, arm64_tahoe:   "d76bba33641e32c980133c38312fd3fa276c46fcaf729f1d795ba3aea5172dcf"
    sha256 cellar: :any, arm64_sequoia: "3fe66ae50ed4cc43684b16083ed5f8cea0dcd91c5d48ac208b5360e8830a54f1"
    sha256 cellar: :any, arm64_sonoma:  "39f54e35fc02a37088b2332f2beb59b4332c82341965b25ec6d66ec77b5b65ce"
    sha256 cellar: :any, sonoma:        "2a44c5bd6312e7c45cfa1107507cbf01c5a6cdc001aca9e5bafefb6826ac19ca"
    sha256 cellar: :any, arm64_linux:   "b4c55c2f31bc82147fd9afd4998a0d69bf4d44cd61e13e47a8f6e62cd442e892"
    sha256 cellar: :any, x86_64_linux:  "dfa5f3d7406d715af54411c27fb1e82de10a78330b9b0709325b086c56336978"
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
