class CloudflareDdns < Formula
  desc "Cloudflare Dynamic DNS Updater"
  homepage "https://github.com/wyattjoh/cloudflare-ddns"
  url "https://github.com/wyattjoh/cloudflare-ddns/archive/v1.0.1.tar.gz"
  sha256 "e13ab6c203eb646ebb23384c0136f469b8e72b05d31f43f288ff9671e601809c"
  head "https://github.com/wyattjoh/cloudflare-ddns.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/wyattjoh/cloudflare-ddns"
    dir.install buildpath.children
    cd dir do
      system "go", "build", "-o", bin/"cloudflare-ddns"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cloudflare-ddns", "--help"
  end
end
