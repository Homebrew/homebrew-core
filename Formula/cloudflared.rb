class Cloudflared < Formula
  desc "Argo Tunnel client"
  homepage "https://developers.cloudflare.com/argo-tunnel/"
  url "https://github.com/cloudflare/cloudflared/archive/refs/tags/2021.11.0.tar.gz"
  sha256 "12b0f4cd3c82ad78375a9ded491453bb3fac868ec485091a43bec709848a7872"
  license "NOASSERTION"

  depends_on "go" => :build

  def install
    system "make", "cloudflared"
    bin.install "cloudflared"
  end

  test do
    tunnel_list_output = shell_output("cloudflared tunnel list 2>&1", 1)
    assert_match "Cannot determine default origin certificate path.", tunnel_list_output
  end
end
