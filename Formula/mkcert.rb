class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v1.4.1.tar.gz"
  sha256 "b539e11ac0a06ff4831b76134b8d391610287cf8e56b002365b3786b96e0acbe"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7cc76858dc35c6d3aabb07242ab6f5f079c4cb85deea4a9f66114528980914b" => :catalina
    sha256 "9100c7f044d91e6ca0c483ed572217de28daa34c04fa6e2a130116175ba162e9" => :mojave
    sha256 "f7d3255bc7f40e66bc75fd6ebfacc6b02c91514f412de9cf4b85b0d332bc4931" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/FiloSottile/mkcert").install buildpath.children

    cd "src/github.com/FiloSottile/mkcert" do
      system "go", "build", "-o", bin/"mkcert", "-ldflags", "-X main.Version=v#{version}"
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
