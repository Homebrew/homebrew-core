class Kedge < Formula
  desc "Deployment tool for Kubernetes artifacts"
  homepage "http://kedgeproject.org/"
  url "https://github.com/kedgeproject/kedge/archive/v0.10.0.tar.gz"
  sha256 "f1191e7c8c207fdca7847022678173be487c3e36d35d7a1358ff0dba31b2ca3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a00649638d62944797c44cc139afd83784a8fdae98ca66c53fdbf868a1dcfb55" => :high_sierra
    sha256 "722e02207ba714534b42b539330a55402d7a093d40033a43b80cce1d560c0857" => :sierra
    sha256 "3587e7c6408d690a4968281e947c7e163cff673396853e8285d239f141aeacf5" => :el_capitan
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
