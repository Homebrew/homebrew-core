class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.6.13.tar.gz"
  sha256 "1a80981273917912ff905e0a26218c784053f4e130f7634d4920e820074fb65f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c476a3cbc4117d43108eba9907dcf511875b431eb559a9ce8c53aee3b5660a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93129ebc67d9a213f87d7a6fd5cf485414614f7d811eda0cea628cf9afc43b1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b8c5ce534adef8ef0b5bc6cdd7509de734451dcfdd2e568318462e8ebacfc58"
    sha256 cellar: :any_skip_relocation, ventura:        "9ad8761dbef6d17a847fbdee428d55e8e18fe06ae991f59f7c112f4519724612"
    sha256 cellar: :any_skip_relocation, monterey:       "25aa6148b829897a8cb534838c2e344db647504d3db767bdbba83f3d7545990c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7854d383d1e3f3a3dd5df907fefce20cb82230538b5f7ed11a48d103f20ea26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "078e5057ee768e0e7b33a38d017e1a11188d1286536bd5bb39242aadd4a17e63"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")
  end
end
