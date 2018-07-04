class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v0.9.0.tar.gz"
  sha256 "cae5871f83cb4c43e0475b69cf6325e5f731a8597e1557a4e9f042510f93d45b"

  bottle do
    cellar :any_skip_relocation
    sha256 "7484ce28ecb0dfc0c7c7b259c2ec5470e7d8c2efbbd7760232f9d07e8fa106fe" => :high_sierra
    sha256 "9ba69b3de8dd600c984e919141e61342dc1b0e237e37580f5856d60eccec4876" => :sierra
    sha256 "74a03a3773ac17d92684a0e5de071f2429f67ab01fc77b79050db78374321f57" => :el_capitan
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
