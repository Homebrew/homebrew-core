class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v5.0.3.tar.gz"
  sha256 "b235cc4830948dd9f90e4400cf008c4202b50f03400f7a44beb79dc093e5be93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4d5ff93543fbb297fb53a0112e884263d1713cb0867d0c3a14898a01d5fd336"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1abc015fec4ea57f3d505dab8449941c2a36744508fb2da5e14f8d2e280e5b3"
    sha256 cellar: :any_skip_relocation, monterey:       "0e86e791c2a919ecee967e1d9d1049d041b985cf0733916cfb4b806f8a2795dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f93f815b73cba1d0d28f8eb1a77a9d84e68291cbff4857f6f4cef304b1f2152"
    sha256 cellar: :any_skip_relocation, catalina:       "bb200f4b7adbd363107f341d0c5167bf7524566a37831ab8ba250aced0a015e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e3a1cc261ead9135965b689379a7d9146669b277d0d5e74f8e653f0243a8b5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
