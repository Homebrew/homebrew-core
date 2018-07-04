class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v0.9.1.tar.gz"
  sha256 "4dbd1f81398d97c08c05516819bf399c010c5d2bb06a53a94ce93dd8cf243526"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7d7f6953c715961a039c5f759059b425589bb7f005e130525fed75704950182" => :high_sierra
    sha256 "687edb1753f91797d46e2dd5c50bc7603de1ae1235dfa37a2a611f0e4d5b67e8" => :sierra
    sha256 "47bc908a985edd34b71cb6dccb66dead174a5395b0dc27a73115e2fda963b64b" => :el_capitan
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
