class CloudflareQuiche < Formula
  desc "Savoury implementation of the QUIC transport protocol and HTTP/3"
  homepage "https://docs.quic.tech/quiche/"
  url "https://github.com/cloudflare/quiche.git",
      tag:      "0.14.0",
      revision: "4d411c22413835f2d57f993d1c90c07813f803cd"
  license "BSD-2-Clause"
  head "https://github.com/cloudflare/quiche.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a0cfd96befac15ff1d0d0ffc3470db2d2d122f6a2a9b2020512bf4a0d5bf060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2be3d9e9a7923c8dff8fc3c686a18cafebd2f48af8b5d34217e9b56135a95caa"
    sha256 cellar: :any_skip_relocation, monterey:       "bdb628c8562a013335107764358506d7be120e4c08ecf9ea7351e6388d15f022"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8335baa606202a1f903e6cd046aae6e86366ccf67aacf83a14a57d0f9fc9814"
    sha256 cellar: :any_skip_relocation, catalina:       "5f983b055f6b0265d34b06e53cf08af00f4c1d3beec9db4afe2f1f1464cde1e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "667f23ac78dc13cc4f574d95afb1fbc43f04ae82a7ae43dd448a420f65ce855a"
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
