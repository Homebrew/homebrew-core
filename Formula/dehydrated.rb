class Dehydrated < Formula
  desc "letsencrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.de"
  url "https://github.com/lukas2511/dehydrated/archive/v0.4.0.tar.gz"
  sha256 "611da321330ffd43d1dc497990b486b2dec12c59149803ad7d156980c8527f48"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/lukas2511/dehydrated").install buildpath.children
    cd "src/github.com/lukas2511/dehydrated" do
      bin.install "dehydrated"
    end
  end

  test do
    system bin/"dehydrated", "--help"
  end
end
