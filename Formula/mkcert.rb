class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v1.1.1.tar.gz"
  sha256 "9b44ce4c5d4539458416ae9e84a0fec8df92592bef4d9198c42f793df684af73"

  bottle do
    cellar :any_skip_relocation
    sha256 "a72c7d0ed6880960fa7124ad1e68e67a9c471f100fc856a794bff15721b19620" => :high_sierra
    sha256 "976ef4ed36ecbde9e13d540781e4cf1a9844c173ba4f75bfb9d6737fe83cdea4" => :sierra
    sha256 "664d321bf8892d67f3506aaa2cd54b496536111fd779513c893e267a7a99bf29" => :el_capitan
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
