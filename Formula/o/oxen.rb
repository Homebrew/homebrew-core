class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "56df64f027be2d879fa1014c5e2bc237354227aac5da156dc7e6fe93bdb2f866"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1b6894b73776bbe2742cab33b7045da7ec5eaed1e468eff7beab8404be858dd5"
    sha256 cellar: :any,                 arm64_sequoia: "f515c1d40286ce4349bb864650772cfd201baf8f9671890787be70d1cbaa08c4"
    sha256 cellar: :any,                 arm64_sonoma:  "8879683186a6b1940bb941c7b4ec79d2b1def2db745a3bc5ac5de471c77bd027"
    sha256 cellar: :any,                 sonoma:        "e4b6eb4f28f04f202e1c8f6a4e5c4be679eeb85f1f8318e0f20f5e22f87671ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d6e16f1934ff862c18fea462d259543e3d04cbb50d6b4d141188d1b1307071d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5a70f9754bb0055216c7fd5108e9771530bb79fc819024ec625c840298e01a1"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "rust" => :build
  depends_on "rocksdb"

  uses_from_macos "llvm" => :build # for libclang

  def install
    ENV["ROCKSDB_LIB_DIR"] = Formula["rocksdb"].opt_lib
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
