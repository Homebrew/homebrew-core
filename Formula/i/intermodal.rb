class Intermodal < Formula
  desc "Command-line utility for BitTorrent torrent file creation, verification, etc."
  homepage "https://imdl.io"
  url "https://github.com/casey/intermodal/archive/refs/tags/v0.1.14.tar.gz"
  sha256 "4b42fc39246a637e8011a520639019d33beffb337ed4e45110260eb67ecec9cb"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "852b6c8f3270eac4536874bcd3569c7b356f196095395587b827c19694bc8850"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8a4fd8dbae699ee5489ee270a44217875c278e8dafd4b0d2ab59c0a53c233d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f97365296218ba43ceae80cc225a3ede3974b0060dc6e22b0e9c7bb10fc10ce5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d67ee890e7374157bff784bc6a756b0a38156c90bf45dfbeed40860a060b82bf"
    sha256 cellar: :any_skip_relocation, ventura:       "729f1a952834a171ae49923079e207ff23dca4df44975f22057cb3c7df555c7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ebd7eddf899a9fd8880bda08f54e4b46da5fcddbc60677a07fe43bd9a407bf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "302d5f8fcf0869b8dd99ad396a04ca70d4f4a07cdc500de72cd01dec07fccba1"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "run", "--package", "gen", "--", "--bin", bin/"imdl", "man"
    generate_completions_from_executable(bin/"imdl", "completions", shells: [:fish, :zsh, :bash])

    man1.install Dir["target/gen/man/*.1"]
  end

  test do
    system bin/"imdl", "torrent", "create", "--input", test_fixtures("test.flac"), "--output", "test.torrent"
    system bin/"imdl", "torrent", "verify", "--content", test_fixtures("test.flac"), "--input", "test.torrent"
  end
end
