class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.3.20.tar.gz"
  sha256 "b3ba6cca3b314a823232d64ad7d93b451e657314ab03aea9b0dfbf599a94d21f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02383304dd2f73ef387db1a8dfce5eee60b1fa02cade5ca936368347909b024e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31a6f71b436a15a0a1c97ac41493746ea0f40b581ac66ee3fa89874e510db511"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a488c77b23bfd507c28b13e944102e83192e5f24cd59a1f8dcb0692ce308e35"
    sha256 cellar: :any_skip_relocation, ventura:        "aedb3d12b9687f8ef0aea742013d98ca0e52562d44723c15489f8332f07859c7"
    sha256 cellar: :any_skip_relocation, monterey:       "3afa800f2a50d6fd4439794a6f03da857b1d114520f1ec7cfb0c4a8efd2a476b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee554cae3c284c1e50f2ae9cf8a74cca5e3e79983f39a067b124791b2ed94649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "272f6280f075ffaf2992346e5a6b4fa5116c87a66f382bad65cecb6433cb8b7a"
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
