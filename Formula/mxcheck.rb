class Mxcheck < Formula
  desc "DNS records and open relay checker for e-mail servers"
  homepage "https://github.com/steffenfritz/mxcheck"
  url "https://github.com/steffenfritz/mxcheck/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "512e7fb7fcbcde0f006c35e61690b7bcb3a68b81ff909431cb2b6069793d3cb5"
  license "GPL-3.0-only"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/mxcheck"
  end
end
