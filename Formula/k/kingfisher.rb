class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v2.18.1.tar.gz"
  sha256 "db51ea67d4d8de7917b286b3ede43ddd9eda333438d70ec0a582718f84cd7069"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "97c2efa21419e07c580f382e58cb5de2f621eedb6c97dbaecc7877e80fb589aa"
    sha256 cellar: :any, arm64_tahoe:       "97fcada7a161c64aa4ca7e4e7f22f5c4da7a1e7e5a5e89719448116e64b584ab"
    sha256 cellar: :any, arm64_sequoia:     "c7115b3224979cdebeaeefdcaaac18c06ed3c645e91fe22e02029af7cd0b1850"
    sha256 cellar: :any, arm64_linux:       "24d9cc758fcdae5f2069823691d840c70d80d6c756db6d4016da6468db65b4e4"
    sha256 cellar: :any, x86_64_linux:      "07487fd92476fc2e6c469d747fc1b03198b462923a18bf6dfee3ca8fd8887e44"
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
