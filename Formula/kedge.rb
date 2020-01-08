class Kedge < Formula
  desc "Deployment tool for Kubernetes artifacts"
  homepage "https://github.com/kedgeproject/kedge"
  url "https://github.com/kedgeproject/kedge/archive/v0.12.0.tar.gz"
  sha256 "3c01880ba9233fe5b0715527ba32f0c59b25b73284de8cfb49914666a158487b"

  bottle do
    cellar :any_skip_relocation
    sha256 "3edff5947ad6460ff5132a9f1722d12e9da6c3644138275b0f3423dc14efac3b" => :catalina
    sha256 "2302d114b01411cef00669faf00e32f1db551a9ba10402398720ca7a56cac0ec" => :mojave
    sha256 "ff1bf61801e5c5e17ba83abe714c4d30914a458291cdc0fc4654ee952a919c4c" => :high_sierra
    sha256 "39f193757913fc743191091a86b5d162b4cb4af618975db1ecd649dce7a08941" => :sierra
    sha256 "1ff9804be018e8bf5bd0668ce1e1a647ab04005b4ea34fb22f49c50c215b4e13" => :el_capitan
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
