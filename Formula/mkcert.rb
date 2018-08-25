class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v1.1.2.tar.gz"
  sha256 "e52453a75d6674222a738dc67a3e78ab671265f4f03fda09ed38da1a7022166a"

  bottle do
    cellar :any_skip_relocation
    sha256 "30680c4b3a1865ccf67b7f44ffc75426cbadaf22676c5721bcacd0940658b790" => :mojave
    sha256 "f6c81b5fed7efd48b60238ee2a415b755ef3bdc3127da64a2d5413efc870e02f" => :high_sierra
    sha256 "9f86cdbc07a6e399dc5df6a68f4f0b5c1c4df5e7d9fbf8bf02b9ca7e2a3b2f60" => :sierra
    sha256 "7e6816732e9f158cd2b012982f55446964d648dc43c75d4686f994c3541e3036" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/FiloSottile/mkcert").install buildpath.children

    cd "src/github.com/FiloSottile/mkcert" do
      system "go", "build", "-o", bin/"mkcert"
      prefix.install_metafiles
    end
  end

  test do
    ENV["CAROOT"] = testpath
    system bin/"mkcert", "brew.test"
    assert_predicate testpath/"brew.test.pem", :exist?
    assert_predicate testpath/"brew.test-key.pem", :exist?
    output = (testpath/"brew.test.pem").read
    assert_match "-----BEGIN CERTIFICATE-----", output
    output = (testpath/"brew.test-key.pem").read
    assert_match "-----BEGIN PRIVATE KEY-----", output
  end
end
