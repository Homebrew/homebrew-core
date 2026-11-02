class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "57e452913097c13614ef9c76d95264571a8580f30f6d4d52e6eea70437f6dbb8"
  license "CC0-1.0"
  head "https://github.com/Y2Z/monolith.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25053bd4529fa990b48e8a23d716d9cfffc9ac8c77c38e7b57351120c4c0b062"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "19dbdbfd463caa6f94ee602a083712b6718ede072ac7d369235cd0f674ecab89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2d2df83fb0c13a9654419360f123494f30d348a206c9e9c01acf5196b7d30c6"
    sha256 cellar: :any,                 arm64_linux:       "8aafc3eac7b777e0d1de6f7d64450e387e003c19a438f3a259710c4248f82506"
    sha256 cellar: :any,                 x86_64_linux:      "a9c846fdb1fef0f5ec0a3218f03ea4342c03e0fa1e29d9818ce3c006ec4e8e00"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
