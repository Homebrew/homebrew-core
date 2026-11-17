class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "1120826802f8782e22c3086f22d11db8626c4afc91b9460e794afd0f8a6ab05e"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "51ba1871f9e1f7272fc9f39a5ca75a8ed315aea5709f44e067f1d8b0e198212a"
    sha256 cellar: :any, arm64_tahoe:       "a62015e6b8d0caf0e486384adc1e77719f8de8cb47be0855f96f85772c597329"
    sha256 cellar: :any, arm64_sequoia:     "57b286b3477b7969d19f14bb5eadca85b392a134e8f5325bfb984382708b3235"
    sha256 cellar: :any, arm64_linux:       "a151f7a40b580ccbe2a991518c31f0215a41cd6c05bea282e927b7a6c1051fdb"
    sha256 cellar: :any, x86_64_linux:      "3cb39a35e6ea7ed0e412258221d2ae383fb3c2d899e906fdbc784357cc877a68"
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
