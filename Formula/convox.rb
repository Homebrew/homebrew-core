class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20200113140352.tar.gz"
  sha256 "01c422498a78a9f2eb71a262c6d390581d5ef1e2bfb105f71e9437eea195d82b"

  bottle do
    cellar :any_skip_relocation
    sha256 "962522e6aa77359754722e15addf80d7ec494d762d6141cab01cb56259ea5797" => :catalina
    sha256 "5050bc28a431d46a15fe106ac2b73c937e94ba97a3cac1f4840f05d8b957eced" => :mojave
    sha256 "61f2f66dca5b353049f9c3768a3f005c5bc24a5b72e9ab939e774f032d237eed" => :high_sierra
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
