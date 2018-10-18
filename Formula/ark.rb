class Ark < Formula
  desc "Disaster recovery for Kubernetes cluster resources and persistent volumes"
  homepage "https://github.com/heptio/ark"
  url "https://github.com/heptio/ark/archive/v0.9.8.tar.gz"
  sha256 "9e293363f4a5f53a77561f204b2055a29beae353b351e993fb62672f30cc93c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "af626aa5d2b6bb11aaeaf3fc81ee6397abc07112318be8a37629fd9b075a98ab" => :mojave
    sha256 "74064bb69d22ff6dbbc9bd1cb39094dba89466ba199162e64146d472547351e3" => :high_sierra
    sha256 "c479b272e50ead4ae7a12bc55fbc8209e4565612225def58befe40fdce637831" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/heptio/ark").install buildpath.children

    cd "src/github.com/heptio/ark" do
      system "go", "build", "-o", bin/"ark", "-installsuffix", "static",
                   "-ldflags",
                   "-X github.com/heptio/ark/pkg/buildinfo.Version=#{version}",
                   "./cmd/ark"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/ark 2>&1")
    assert_match "Heptio Ark is a tool for managing disaster recovery", output
    assert_match "Version: #{version}", shell_output("#{bin}/ark version 2>&1")
    system bin/"ark", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/ark client config get 2>&1")
  end
end
