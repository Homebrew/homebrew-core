class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.10.31.tar.gz"
  sha256 "8a26bb199ccddcb8fbaf5a8f4a209444a92d92e3901e27acbcd824695acfafc7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fba9e93cff2fbbf56a71338af60cb5f12a5529bd0f51807d62b8ecd9cd6dc9a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea1244472e2206991cc5fb8677449ff613c9e77af08d856b39f20931ba1aa06e"
    sha256 cellar: :any_skip_relocation, monterey:       "478bf84f202d992ba666ba53f3a93b3a32a69fa2605857fe4cbec1c4678ac072"
    sha256 cellar: :any_skip_relocation, big_sur:        "24d80e1b639b4f84542d188ad4b3363348b142b69d0812ac2d7fcd1c790dc364"
    sha256 cellar: :any_skip_relocation, catalina:       "45b89c5ce500478879ea7b0b618060e3803b34b448385e724bc5c4a1d4765ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1227c7749cc889a8ae3a12ba71798dfcfc5dbd345ea15df5bd0c8bf9ef761ca"
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
