class Mkcert < Formula
  desc "Simple tool to make locally trusted development certificates"
  homepage "https://github.com/FiloSottile/mkcert"
  url "https://github.com/FiloSottile/mkcert/archive/v1.4.0.tar.gz"
  sha256 "8ad11055b4fb47955312b7b72e24057cc6dca1606d14838a1520ce87ed62cc89"

  bottle do
    cellar :any_skip_relocation
    sha256 "84405d6ddce6b9fd5ba7445649296180a7e8c829d76f54c73fe34b813572771c" => :catalina
    sha256 "c25aa60f7834b2dc0bbe3faff3540e4a55a4b9e416886bdbd59cf34eae11fc5d" => :mojave
    sha256 "74e8f0d397b3eafaf574f6333871f2792ee22b4b9fe1b9fb2031bb3832d55d91" => :high_sierra
    sha256 "990c966d52f0cbae4e0e67795e54ed47cf1efe5933667e58c403974fac04818c" => :sierra
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
