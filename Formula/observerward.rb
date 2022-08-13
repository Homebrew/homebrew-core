class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.8.11.tar.gz"
  sha256 "17a9ee8e4a29debaa92b7af1c2f8e72149a01e9673c493128e922fd47a49a8e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4caf1f9da039196f13ab289ed6086bd6457848a3af54e5d650d75002a2e574d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b68411bf29361a6db176f8ddec25c47c47360a671a8aa14406e0334775a9fa98"
    sha256 cellar: :any_skip_relocation, monterey:       "70c902fa67defbea2c1e83f48f7f06819048e6db35b96511ef8d9156d4bd4afa"
    sha256 cellar: :any_skip_relocation, big_sur:        "858036bf32d5c590d0bd25722b947e2a629a34512bfbef4f5a66a019e59bb10e"
    sha256 cellar: :any_skip_relocation, catalina:       "bf1e07b802e4f14580423ff16ffff2f503651b7cea4383ef098591166c3f4c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d478d6238ad34d783bb35a61b645fd2fd3d408fae11feb8572e7b746cd84e74"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
