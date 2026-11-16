class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "a3e733e0fffa9145768aef886b6629b7938998b99d2c013302912967963a0d6c"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1337436e53c57dcb5ebe9c259b8ef9d8531a2c73ce450967f6eaf74609724c1c"
    sha256 cellar: :any, arm64_tahoe:       "88179e6e8f9f4c4e70dccb505eb3dd8685ef7d77cee9f531299dc0ef5d8648bc"
    sha256 cellar: :any, arm64_sequoia:     "14e216d071e396eff7ae25f75b77df19b33d8cc569fc45b00b3e615eee7b1d9e"
    sha256 cellar: :any, arm64_linux:       "f90f5ec2811ab5d1cfab5522a56ebd57a640228093695bc30847f5579d5d39f0"
    sha256 cellar: :any, x86_64_linux:      "402ff0caef30d799f78c297657d03251c372d292bf7d4aa0161b129760d74298"
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
