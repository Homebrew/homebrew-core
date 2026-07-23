class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.52.3.tar.gz"
  sha256 "25e0b63b8a6bf765084b242e5684abc2f2fc46854d34da6a1c6add09d6295d83"
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
    sha256 cellar: :any, arm64_tahoe:   "ed585cc90531191138ad9b568a25236253395c5707eecfd7c65a5ca9b8df29bb"
    sha256 cellar: :any, arm64_sequoia: "6adb7c7fcaf618613daf30019e539085861969666622f2b490ab5c10710389ff"
    sha256 cellar: :any, arm64_sonoma:  "ce29dc5d39cfc18673ee0d44c6670b993519575c3cf78fc2dc3502c882f53f82"
    sha256 cellar: :any, sonoma:        "051fe637e62dd45677103c66f7c01e938af993ef57a1603dafa8fe687eab2f22"
    sha256 cellar: :any, arm64_linux:   "466614a1519ff97e63ee5565a1371e02372b6c51ac9e97c5ea1a8c6317f09d82"
    sha256 cellar: :any, x86_64_linux:  "eda2c946842abd6b334a1aa89d872e3cfad6c2eed5fda1006cfab372bbb0f16a"
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
