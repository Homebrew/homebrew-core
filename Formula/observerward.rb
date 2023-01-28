class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.11.14.tar.gz"
  sha256 "9fee36957715f93d88662dbcc7ee709426c9ac87c9fb6c5d90e3dc9e6d4b65f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8860c58f481bf4172771b28370dab262e18926694ec1739259ee728bf98ffb5d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66705f6b12211b0d5c12f2e285d6a56f6ed8263ca03b4f91d204950e91c3d3cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d111937a360409da01e8889de59ddbc1bdb1d5c8ffbb0b56c2c9d48677cebcfb"
    sha256 cellar: :any_skip_relocation, ventura:        "4c480a710356e448c7fa20da3ce9167cd9d02e4bc8fa13faee2ca9f8061ec49c"
    sha256 cellar: :any_skip_relocation, monterey:       "35da5f3048c6ee3d3b608b3f9235809453f94b2a5c72e8902ff7a71a271b1420"
    sha256 cellar: :any_skip_relocation, big_sur:        "a15bb5a7c293fcf58bf7630e0a86bab8a60be2c955983e3c55f9deefd5f742a4"
    sha256 cellar: :any_skip_relocation, catalina:       "782cc498ee96bdeb2ce4edb63cbc3972d3fd20a4b1603b85d5b8e021bb50edaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bcc71e08e9b666646162ed0165365aa5b8e4cfa2998705dc20639e075a3a9f9"
  end

  depends_on "rust" => :build

  def install
    # Fix a segfault when built with rust 1.67.0.
    # Remove on next release.
    inreplace "Cargo.toml", 'prettytable-rs = "^0.9"', 'prettytable-rs = "^0.10"'
    system "cargo", "update", "--package", "prettytable-rs", "--precise", "0.10.0"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
