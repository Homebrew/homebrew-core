class H26forge < Formula
  desc "Tool for making syntactically valid but semantically spec-noncompliant videos"
  homepage "https://github.com/h26forge/h26forge"
  url "https://github.com/h26forge/h26forge/archive/refs/tags/2024-07-06.tar.gz"
  sha256 "66e3bd1f63e6c70db334d103107ced2b2924aaee6472c71682ed34c8276203b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f1c1f2d0a4dcfaccd11770de03afbfcba696294d3167519fe72fc122ad4984f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d06793175eeeb5e1aea26650c793e33e06e9dfa9e53e422055cbf44d3ebe3909"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca2e2d0171e3ea766da1fd0cf238a5b1a6f97addf518e4346810eabcd4a1b8d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a76d3cb2f83f178bb60ebc6b79efbde31b56c4c500f7ad901b8f306dcb826eb2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa2c3be208f76107b4f5c6312ade500217edfe4f1478620b149fb9cb93f5a872"
    sha256 cellar: :any_skip_relocation, sonoma:         "00dc5feba7341d70ec4bd024f63de066cf1574b97832e87e2496ee268dcf5e5d"
    sha256 cellar: :any_skip_relocation, ventura:        "ffe426e9eae46e983558bc76e27422d94837af5fb7260efaac0dedf0381fb6d7"
    sha256 cellar: :any_skip_relocation, monterey:       "25cbb1705a0bdf656e6cde346f458fe9e89975d0846f1411532b07cd089212b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c37e9c31fbd4ef981277a591d851fcf9a1e10f21689917d698709a7b086ab0fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "800da50e33cdc4bbce4222275b0337685a7aa3cea4bac0029c99b963d997a4f4"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" # for libclang

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"h26forge", "generate", "-o", "out.h264", "--seed", "264", "--small"
  end
end
