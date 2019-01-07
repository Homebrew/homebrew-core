class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v1.2.0.tar.gz"
  sha256 "5889775924122e196235ced42434c8c58d101188b725154a3424d1c8a4d10d14"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "43c612e9b1710c731f72ada42b3bd3b76a9328bf3781cc96fb45e2de83265d18" => :mojave
    sha256 "5e56d2812c8afac13db6b9ad15175a54847733d206ea5db3c8af0faa6734854e" => :high_sierra
    sha256 "e5bbcfe3e83fe427c8b9a6b8b3b88a4d13168190721ad057167112fded2c27da" => :sierra
    sha256 "5ce2d4d5e9fb7f7122cbadf7dc9166b64e8854351f03c5cff1aefd9e4485a96f" => :el_capitan
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
