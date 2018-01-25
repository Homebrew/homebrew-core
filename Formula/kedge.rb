class Kedge < Formula
  desc "Deployment tool for Kubernetes artifacts"
  homepage "http://kedgeproject.org/"
  url "https://github.com/kedgeproject/kedge/archive/v0.8.0.tar.gz"
  sha256 "da4c4c11f01308d0201d6897906e3fcdef51220b1bc56ff872857ddb4b7a60b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9704c309b415c9e756537e5c186a9e16faebc685d2ff650d692c112ee991f6d" => :high_sierra
    sha256 "c94933faf06cf4ee53208a6c98074984ab31ba237d82849f593f77233fb02fbd" => :sierra
    sha256 "361ac5670a50b255857ed247b9e989272b4924530317f95c451f1cee7e976068" => :el_capitan
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
