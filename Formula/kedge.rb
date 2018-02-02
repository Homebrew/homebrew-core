class Kedge < Formula
  desc "Deployment tool for Kubernetes artifacts"
  homepage "http://kedgeproject.org/"
  url "https://github.com/kedgeproject/kedge/archive/v0.8.0.tar.gz"
  sha256 "da4c4c11f01308d0201d6897906e3fcdef51220b1bc56ff872857ddb4b7a60b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "24cc6de1fb74189044ac5b3e9edc13045967c9d74d90a1c1139a73eeda9bef2e" => :high_sierra
    sha256 "fc046a26eda1adaa61d3c90690afe9c66e9a313205084193e44ed2d0d0905d72" => :sierra
    sha256 "2b4ca695cd31d3f8ceb0cd9801101437d4464a04998ed0a777088b0f35a7e2a4" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kedgeproject").mkpath
    ln_s buildpath, buildpath/"src/github.com/kedgeproject/kedge"
    system "make", "bin"
    bin.install "kedge"
  end

  test do
    (testpath/"kedgefile.yml").write <<~EOS
      name: test
      deployments:
      - containers:
        - image: test
    EOS
    output = shell_output("#{bin}/kedge generate -f kedgefile.yml")
    assert_match "name: test", output
  end
end
