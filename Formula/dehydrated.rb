class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.io"
  url "https://github.com/lukas2511/dehydrated/archive/v0.6.5.tar.gz"
  sha256 "10aabd0027450bc70a18e49acaca7a9697e0cfb92368d3e508b7a4d6d69bfa35"

  bottle do
    cellar :any_skip_relocation
    sha256 "d21b6d1cd29019957b14e7dcfb73a95efd9dcff917cdf983227b4b1defcc3a80" => :mojave
    sha256 "d15ef3ebfbc9bfc48c16192a885bf5580f0269f05a62e569b18e18049cbe917d" => :high_sierra
    sha256 "d15ef3ebfbc9bfc48c16192a885bf5580f0269f05a62e569b18e18049cbe917d" => :sierra
    sha256 "d15ef3ebfbc9bfc48c16192a885bf5580f0269f05a62e569b18e18049cbe917d" => :el_capitan
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/lukas2511/dehydrated").install buildpath.children
    cd "src/github.com/lukas2511/dehydrated" do
      bin.install "dehydrated"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"dehydrated", "--help"
  end
end
