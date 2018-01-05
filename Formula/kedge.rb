class Kedge < Formula
  desc "Deployment tool for Kubernetes artifacts"
  homepage "http://kedgeproject.org/"
  url "https://github.com/kedgeproject/kedge/archive/v0.7.0.tar.gz"
  sha256 "61fc71632efe79928f92bc6b4bb2ac1c33c6836494afedf25190703d3346b182"

  bottle do
    cellar :any_skip_relocation
    sha256 "62ee80927a06946cd6c4cce905de732f98b0bc71d6a637b6faff7c3878d9fc24" => :high_sierra
    sha256 "c7446f35e6eaf85b6fb8dfbf16c2c6f23324f20c6cfb89fb5f07d90d0ab544d4" => :sierra
    sha256 "c80dd62de6e40378c8b0db2dc567baa72d2d8faf1d5b2bae5f2f8766eeb7504f" => :el_capitan
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
      containers:
      - image: test
    EOS
    output = shell_output("#{bin}/kedge generate -f kedgefile.yml")
    assert_match "name: test", output
  end
end
