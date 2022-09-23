class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.9.23.tar.gz"
  sha256 "08a5177bdc51d6048c877a1f958ca180e3fc05a7f3e146881fbacc2264966767"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7036fd8037cad48b32235dc9541b7ed2e79781f81c715b6dcceb3979832de0b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15425f0121eab0794e124bbce180a1827ae30743c1b2a42c4928e531ad29e89f"
    sha256 cellar: :any_skip_relocation, monterey:       "908c7c2a4d0f3e6f56ff6452850f140c27aeb50f8ba29d4a7187c02cfb8e3d5f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3a0d10ee24706858f20bea4a6d2427e4c44195fba59b422ef891f13bbf83e9d"
    sha256 cellar: :any_skip_relocation, catalina:       "986f724edde991fd30444da28341a7306fb8c485c55ce0b99460652f6b6a1499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "232eaaecf33c77690adddbdb02b4b411d1714f817257cd7d18908bc78adedf98"
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
