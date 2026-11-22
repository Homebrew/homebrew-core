class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/", browsed: "2026-10-12"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.68.2.tar.gz"
  sha256 "85cb3f51e8679dbdd98b53ab0f85160a18c7dd77a7f0e6ac375cf9b8b0551c06"
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
    manifest_sha256 "20e4639f79288ab7a970eb82e1833003edb81043bd172c610cdfdcc5d5804f58"
    sha256 cellar: :any, arm64_golden_gate: "60b959eb30a14fc63edc20bc784a38b4a707772eb0341e367c2930920ef727c6"
    sha256 cellar: :any, arm64_tahoe:       "16194b833afa1d3e3da6c4763dc77d241d56225aa9e8d1f896df2d47e0140418"
    sha256 cellar: :any, arm64_sequoia:     "042d7ef809b768a234e0726db9f772e5daa6b975ae6b5fac61b9c09d9569561b"
    sha256 cellar: :any, arm64_linux:       "6e2023cc053310efcec9a700024f33d9573ba68f255061f38f52e41a99056bc2"
    sha256 cellar: :any, x86_64_linux:      "44c181bd54ed1ebb3eb14f381e5f085fe3678da7d4b53c6b132c152c5b7631d6"
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
