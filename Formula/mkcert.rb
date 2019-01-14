class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v1.2.0.tar.gz"
  sha256 "5889775924122e196235ced42434c8c58d101188b725154a3424d1c8a4d10d14"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e14996949666a8c815fc940fdb95541fa84550679703441354f4a9571171ab6" => :mojave
    sha256 "0ce37a72789919e61bf9ab86a39008a9e4bf44e06e57ec53068276e61689f19b" => :high_sierra
    sha256 "08d3fd46f1fd1610c41be55a7d9582e6d58e9e99e3fff257854072cb97022c1f" => :sierra
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
