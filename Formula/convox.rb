class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190717145705.tar.gz"
  sha256 "7e1557f0284044e373bf094da1cd2465aa5aa0d1be3dc0941d072260977ea6f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddfcb0bde865eaf18f853e77f33dbe0c10f4a1007e7ac30e2490429d9ade8939" => :mojave
    sha256 "b6c47469d4587c28aba0696f8a1f93cfe61dc61580d9df8febfdfdcbea477ecb" => :high_sierra
    sha256 "c7842ec6c810628f82315f0078c423434e42865bc116d8dd9fba50245f21a946" => :sierra
  end

  depends_on "go" => :build

  resource "packr" do
    url "https://github.com/gobuffalo/packr/archive/v2.0.1.tar.gz"
    sha256 "cc0488e99faeda4cf56631666175335e1cce021746972ce84b8a3083aa88622f"
  end

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/convox/rack").install Dir["*"]

    resource("packr").stage { system "go", "install", "./packr" }
    cd buildpath/"src/github.com/convox/rack" do
      system buildpath/"bin/packr"
    end

    system "go", "build", "-ldflags=-X main.version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
    prefix.install_metafiles
  end

  test do
    system bin/"convox"
  end
end
