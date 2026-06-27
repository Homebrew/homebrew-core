class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.50.6.tar.gz"
  sha256 "674565712c542abb8a6ae63ee5de1d98b206fd414ad11808da680b0766ec30e1"
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
    sha256 cellar: :any, arm64_tahoe:   "37dbb57f2289a3abd38b90cbfe0f83fe5fd6ed5dc054cbac867c23b2e4f06f59"
    sha256 cellar: :any, arm64_sequoia: "54a85c57212b264f5b1d0706480904a2a2f4bfa951d39e7fc4aecf4c0d2d11cf"
    sha256 cellar: :any, arm64_sonoma:  "c9369a9b7af0e4756155d5a3087e77cdd39f470e64ce18b26220a2f72aacdbe7"
    sha256 cellar: :any, sonoma:        "5e97b4897c59b69c83863a8a2e519db5da2f8a1ffccb4753474bfca250d05c33"
    sha256 cellar: :any, arm64_linux:   "15dc299a1fb688d23eabac03f3e90e477155d7f25593e1ab05ff2434de8d8479"
    sha256 cellar: :any, x86_64_linux:  "aaef3893b6840c8ced6fb9febc989235c27d32c92c4b880498eed53f71555e15"
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
