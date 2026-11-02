class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "57e452913097c13614ef9c76d95264571a8580f30f6d4d52e6eea70437f6dbb8"
  license "CC0-1.0"
  head "https://github.com/Y2Z/monolith.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3e8cb0e3bbe4321f25b821d4fe8daa945efa9a25e75973b86936c22de3a83026"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b7008d4021c549398d0675927ee54718f09f59a210fc86123f4a7b8e7cbdace1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "83450f47da8a944d949f4dc3438c48560a5800df53e0d8c03f253d97f257da82"
    sha256 cellar: :any,                 arm64_linux:       "b6083ba71bccf4e7ddeb2b5981b504b248141bd35a869600fd8c088e67dc7402"
    sha256 cellar: :any,                 x86_64_linux:      "b3cf92caceaa22296823297ccf1f2d8cf9132799ed0706ed0b342a8eac552fcc"
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
