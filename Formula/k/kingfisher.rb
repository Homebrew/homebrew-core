class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v2.17.0.tar.gz"
  sha256 "cd809cbd3f65b116493f29897b06185717d6ac5c7df54cc77e48a231808a348b"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "29b6670a33a86812b6634d5e3351f0deebaacd0b9863816d49cd87758cf21cf8"
    sha256 cellar: :any, arm64_tahoe:       "ead4044e16629626d6619d9ce4e9898d9c4f94d35c0f322dfb32d329354bf869"
    sha256 cellar: :any, arm64_sequoia:     "7742f82a6608470e8a6f96e30e0d0c0b03ea86d200d85959dffe29765cfd1fc1"
    sha256 cellar: :any, arm64_linux:       "277a05d7876608bc1d2b90f702166af90e96c644ff60ecc3153580ace8f243e6"
    sha256 cellar: :any, x86_64_linux:      "5c79f8c2e47180afcef6b438490e6a69d7cd6bd46f67649376ab1470be91b7d3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "vectorscan" => :build # kingfisher-vectorscan uses static library
  depends_on "aws-lc"

  uses_from_macos "sqlite"

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["AWS_LC_SYS_USE_SYSTEM"] = "1"
    ENV["HYPERSCAN_ROOT"] = formula_opt_prefix("vectorscan")
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"

    args = ["--features=system-alloc"] if OS.mac?
    system "cargo", "install", *args, *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
