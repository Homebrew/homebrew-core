class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.6.15.tar.gz"
  sha256 "e05a14a8acc0afe7b1a01fd2064bc7c5d9f1f587d004854e816320ae4b2da840"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "169c94f61cdfe889aa511eefe3206e0f18e35a1107b9019dd8b3d01c86607031"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "757b691b203e1b32f55473c23e3d5d5177b4d671e6c811e8838561ce1dcac2bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9c6bb38d9a521a9c5fdd0cd34e00dc053ade22eb5e94a3c6ecf1d8bc3118e90"
    sha256 cellar: :any_skip_relocation, ventura:        "4c66c64712c3d6d102806314c9ee47639fbdd9491b2232728b56de17814f9d02"
    sha256 cellar: :any_skip_relocation, monterey:       "05cff744505965654ec0fd7c0d7d858938d8ed2a687da1dbc30381c6116d03aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fc0243750469971f5af787d0e8ca41c1cdd2e3ed6c234ec6ca7089a29123a76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c1fc60072e563487caae50d3a891b2af99bce7447225a2257d5e6471be4f458"
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
