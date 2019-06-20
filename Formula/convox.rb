class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190620150317.tar.gz"
  sha256 "479d418ca32ec3987db2bba8f20bbeea5dc56060207d2f0919144c8814fd5557"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae4b42cb33fdaff934bcf65f7f0d736820e336b03333beb5209fb7b78e3e9bca" => :mojave
    sha256 "dc4fd6f7e1921ee6cb038ceae5073aeb1e7a24a42a280dbd008b8b3f837abd2f" => :high_sierra
    sha256 "84b60d80a8e3fb1e7b02fe51e66a0b2c4dd58196f8e896a13707fb1799aec4f2" => :sierra
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
