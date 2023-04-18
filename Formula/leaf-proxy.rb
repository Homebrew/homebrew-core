class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.8.2.tar.gz"
  sha256 "bd0a1439f6f4b6b34eab4228069ab832963720dc905d9a0e10f05e1517349756"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec5d412140f7fc2c53536894d311ead84d55908f153620f820b07ebb243e799f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "721d4a9d2f5af08e066f8ccdbe5d3b6b9b3f1b46dad9f655aec6830ac4ba6e93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76874f0cb8ab05107d643e7189e66ac8c144adc5884e317ca18690a655604b90"
    sha256 cellar: :any_skip_relocation, ventura:        "c2dbcdd143a7cc24558aa9b65d58adc74887a274516fb173dcd942382c05f7fa"
    sha256 cellar: :any_skip_relocation, monterey:       "e0cb57886d0aad0b6b25a8a63aed3d599ba40056b61a75dca630b5eb1de8daef"
    sha256 cellar: :any_skip_relocation, big_sur:        "51112bc050c38183a03a45659540de55f9a8f149ca7fe7020de8175b7c64fc1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64ab0aeee3d08284ee8a684bdaeff6eb0d4f61912a4981efad8ad97d81d054fc"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  def install
    cd "leaf-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}/leaf -c #{testpath}/config.conf -t SS"

    assert_match "TCP failed: all attempts failed", output
  end
end
