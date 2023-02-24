class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.2.24.tar.gz"
  sha256 "40d3d7b2d690d15fc9625a47073a94ea44c56fc7bfa2aa7bed4c0d3f57d49778"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a643517e7081c4f1eb03993f757b6adab56deb1eb8996b6dc6b2e6f75c4bfcca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f49a6feb93dc55f20988f3c939b0a4d0547150fd9e614564999458a7c63d531"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d71d6b03e5ad6fec9537e15b7e4d0190277afc7f11a14c620e201ca21f6c7cc8"
    sha256 cellar: :any_skip_relocation, ventura:        "e2e5d0677b7f695bb50664be1273e191d86887bf29e84e843e913debe0b7d923"
    sha256 cellar: :any_skip_relocation, monterey:       "3e0f71590d04cea4310fdc1d8662aac99bc88a606e17bb1c8edd1a9c2e870187"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c166a57d550c986c6224255be564eb6531ea6c0b4c844501d2cf7d7a93c3f36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a18f87771fc17f09345c35a3798f3a5e19906e4f47ce2f226ed7ef129dc21ba0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "update", "--package", "prettytable-rs", "--precise", "0.10.0"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
