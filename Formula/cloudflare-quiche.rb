class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.13.0",
      revision: "2bb385b26bac0018f37ec0a7c6a556a52842e6a6"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89f43bc6e0295a5f0c764ac365324b58ed4235100bcb47b4da83abdbc35e1216"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb168d2c355be50dd64e3128fb5ef4471a204a9b16ea5e978addf5299e9af31e"
    sha256 cellar: :any_skip_relocation, monterey:       "a3d162b960f3e5c891ca45810bd81cfccb75a860393c15fc0119fe45290599f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e63332f10abd8c5f60f66df885756a9d4fbc26ae3c569071b9e281ab3744d2e"
    sha256 cellar: :any_skip_relocation, catalina:       "3f0dc605987441facd63356c316179ff7df3cefe7838d3e45efcd2c198412972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d51deaf7c07263f15788cd16bbfa3334704d1cf61657961f392be6ddf2b51605"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps")
  end

  test do
    assert_match "it does support HTTP/3!", shell_output("#{bin}/quiche-client https://http3.is/")
  end
end
