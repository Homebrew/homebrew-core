class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://github.com/xenolf/lego"
  url "https://github.com/xenolf/lego/archive/v1.1.0.tar.gz"
  sha256 "65af2e455bfabfdede3ebe66162280120462d100d5e647be41b1a30ddffc4044"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1f6fb8aac4e2b88d99c34096eac3c62f336167e9e67d34ab30b5c82e2526e36" => :mojave
    sha256 "e9c70650e8fdaa89f607e7dba86b60bc0d2d401b24d3389c621a534c754f23b5" => :high_sierra
    sha256 "7993432187ead6214d3e21b35fe004da1931eea83d2c88e3a186ec32e02f77e3" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/xenolf/lego").install buildpath.children
    cd "src/github.com/xenolf/lego" do
      system "go", "build", "-o", bin/"lego", "-ldflags",
             "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
