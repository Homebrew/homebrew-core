class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v1.0.1.tar.gz"
  sha256 "fce041ac8becd6cdd2f45a676873b0651e9573baf421f8953dd5ab1d301c707f"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e356ccb74c7c12ed8b1dd0c4d0f9865eade7a885c8e2cb33f85f2e39f56a52a" => :high_sierra
    sha256 "0dae653fbb70fd686941fdc96fe9ba7db533fb45a4612534a842244b4095240f" => :sierra
    sha256 "2f30ce277935e1c81313013379257c3d8733270c755bac936ee001d5d7105694" => :el_capitan
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
