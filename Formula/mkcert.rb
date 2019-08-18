class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v1.4.0.tar.gz"
  sha256 "8ad11055b4fb47955312b7b72e24057cc6dca1606d14838a1520ce87ed62cc89"

  bottle do
    cellar :any_skip_relocation
    sha256 "a75af73ec6914b3a57a9f9e63a1b20af3cfe9fd6129da87e29adbf76d9efeb6a" => :mojave
    sha256 "54ef43d3e7846cce0fa5dc70b54236a29847f4b400216dec9f383d01e583bdd0" => :high_sierra
    sha256 "951c4300cad59315176e100cd347125d18dbeef2100b2c884a1b348bfdd3990a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
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
