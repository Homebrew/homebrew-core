class Kedge < Formula
  desc "Deployment tool for Kubernetes artifacts"
  homepage "http://kedgeproject.org/"
  url "https://github.com/kedgeproject/kedge/archive/v0.11.0.tar.gz"
  sha256 "023f16b5c19d385408041d1b1fd5f307f4fc6d56bb68722f74baa5fa12fb40ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ee6dcd1f7b3dfd28e2e3c84d708ea42af0758042950450e961e1389eb57bc02" => :high_sierra
    sha256 "49330bed015b0d9ec9ade0a9708906273851c9fe5c297b31a7497b575350333c" => :sierra
    sha256 "9e19bd2ee220a44ea866ddcb929e25c81f78282589d44a0ee38192f1d6d3d8f5" => :el_capitan
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
