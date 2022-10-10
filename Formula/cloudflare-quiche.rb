class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.16.0",
      revision: "24a959abf115923910ce18985aa199d85fb602d7"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb5b47bfbf10903ae56c1a381a992682f4fbf27b500893b4c83076499b1f2c34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dacf58c5687daacc599a66b06e34eff89b461f09934f6eb6694a1915b0685bb7"
    sha256 cellar: :any_skip_relocation, monterey:       "10b6ad44ef8278df68b40abd16008059ccdd18c0dd825bb069ff0eb1afdb3a3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "09258a1416c95106b1b1589fa86b894d3f3e7765a0b55be77aba7063e6c089a3"
    sha256 cellar: :any_skip_relocation, catalina:       "610f684aa810ca275be3326e797efc7adf9b9ba49abfafceab284905c6f0b172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0545b69c8ee6d4c8d25bba36520b1b38cf921cfbbf02af91c17ff635fc1570f7"
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
