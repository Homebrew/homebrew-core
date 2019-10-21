class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191021163708.tar.gz"
  sha256 "c0917701eb22e550afa7b6bcd64cc2354caf7a602035460208e088373fafa989"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff2b7829f4a7ef7992ba525c65bd1156a13e64b287b29705819eb956ef043f79" => :catalina
    sha256 "461cc3a859928d200453d027e9f3fe37269825a7610f76c534da496e00353470" => :mojave
    sha256 "2a7a4df0f08ba2599d0dd453239fb2e0b24f1f1c762e1ee910a4212bae4295d0" => :high_sierra
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
