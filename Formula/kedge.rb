class Kedge < Formula
  desc "Deployment tool for Kubernetes artifacts"
  homepage "http://kedgeproject.org/"
  url "https://github.com/kedgeproject/kedge/archive/v0.6.0.tar.gz"
  sha256 "8df6c9251c8ea447c67cda0eac89a145573d4295b11d76191b3da803189b20d0"

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
