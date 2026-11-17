class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "a3e733e0fffa9145768aef886b6629b7938998b99d2c013302912967963a0d6c"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9cd363af26ae4e519079129ff7fcade0faba643015333dab274d6bd347d337ea"
    sha256 cellar: :any, arm64_tahoe:       "41ff7da52829d537b89ffd1292adc9d8b73125ea92bf6b67fd8636eafb949626"
    sha256 cellar: :any, arm64_sequoia:     "418eb34bbc172df11b2f821c82480682880ef041d5fd29c0c381fd34288876f1"
    sha256 cellar: :any, arm64_linux:       "b3b68a7e274da505c51365d97948f26aaf7cb002cb595f68f26e7dceb23dbe0f"
    sha256 cellar: :any, x86_64_linux:      "a075652ca96f91fed7676a1d8ec15bc8dcd58d3c827ee3b3b4835eb5bdc12119"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "vectorscan" => :build # kingfisher-vectorscan uses static library
  depends_on "aws-lc"

  uses_from_macos "sqlite", since: :tahoe # requires sqlite3_set_clientdata

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
