class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.7.27.tar.gz"
  sha256 "cf2d4cb334611520eccb24578eafa679fb5a9a11e53c04620c833c774110c769"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f21837b805e99ac061403a95493f3a29fb31904a438c37700d674b54e95b88bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "986fa9a52e8ad24782abd6eb79aacd1bb0c13661d6202c87aef9d55843922e69"
    sha256 cellar: :any_skip_relocation, monterey:       "3de41ad2ec24db7429e614d375977b98e994c642da07b457e936cd2cee98f35f"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd809da445413b64e18904c50fd879715de71c3705d8fc8bb7ef48ec6e43fa3c"
    sha256 cellar: :any_skip_relocation, catalina:       "f481211645afb8d5213f2de1a7d3d9f3a7388f6634f4ed64b03e2f8734bb4ab4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed393356e07363e413936477af458a1872feb695611055ee6d9d8c7deb1abfa3"
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
