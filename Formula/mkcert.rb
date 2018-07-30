class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v1.0.1.tar.gz"
  sha256 "fce041ac8becd6cdd2f45a676873b0651e9573baf421f8953dd5ab1d301c707f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1750c34afab635ecb8b7701df816989193fb2acf75ef9a7bf1d0fe93fe6affec" => :high_sierra
    sha256 "583a3eb7cfc47a92179eac8e64ea8ee3248d83f75089f930b217919f8e5adb03" => :sierra
    sha256 "134f9ae409af0735d27298646a66ea0e2ec8d919acfac2cebe729c062ddf7417" => :el_capitan
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
