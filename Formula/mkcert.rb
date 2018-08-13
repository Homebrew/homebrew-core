class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v1.1.0.tar.gz"
  sha256 "3b040210e46977921871d8d065b86ac7fec3bcab63d2b96f8bfb2d580d26943d"

  bottle do
    cellar :any_skip_relocation
    sha256 "961fef7c3f09f4777b857db48f8bc6f37390c6747b6617781f9b087bbaa3dfe5" => :high_sierra
    sha256 "050eb6efb186aadcdbaf2d20ed6396074f09e8e777a666955e69fde0ff588198" => :sierra
    sha256 "34f2c89fc0d5cdfd197948ea68d40405887b4eaa048d1402bb4a80555b14c33b" => :el_capitan
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
