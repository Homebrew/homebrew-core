class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "c0ce20db798567a78e4ffd32d2b06d8fbb377565c024a73934dfbdc1010d60bd"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    manifest_sha256 "a6c36b8d357660bccaa8c2beb3ff365d9db994d075cab73944c8f57bd36653c1"
    sha256 cellar: :any, arm64_golden_gate: "3ff341205d3061f5d515edf8a69ee2a66360e1c21582c6a12f0557f0f219cf22"
    sha256 cellar: :any, arm64_tahoe:       "a96cce444ed7d814adb381d7b839b71974ace60dbbbca0a26951d9d2d0e24af8"
    sha256 cellar: :any, arm64_sequoia:     "fe5fb44e1a45dc5d366ff1bd69cf9bece6a739261b6bc9e2676e4ac283cfb142"
    sha256 cellar: :any, arm64_linux:       "9c82dcb53e93c6e3c7092be271a63867c896d61c1083eff88275f43e2d361cea"
    sha256 cellar: :any, x86_64_linux:      "c0c4ceccb1cb853eb4408162e809e8e5aea27eb18820b950d8dd03e827991597"
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
