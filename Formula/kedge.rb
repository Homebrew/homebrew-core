class Kedge < Formula
  desc "Deployment tool for Kubernetes artifacts"
  homepage "http://kedgeproject.org/"
  url "https://github.com/kedgeproject/kedge/archive/v0.10.0.tar.gz"
  sha256 "f1191e7c8c207fdca7847022678173be487c3e36d35d7a1358ff0dba31b2ca3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a96d73fef45a986c6053aac38d97bb6778e3997a507e4f3283021862f470a911" => :high_sierra
    sha256 "30badde832965452f2511bf3c6589fd979585b0da4413d4e1865ab4556a30263" => :sierra
    sha256 "5615be2af0deefdf4046a84f4d51562f1e69c68033ad8b9057edbb243c92c9eb" => :el_capitan
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
