class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190509115116.tar.gz"
  sha256 "bfe0cea866f99f87662548efa1c669bc52b73fbce17f8c4cca898ebc10b68eeb"

  bottle do
    cellar :any_skip_relocation
    sha256 "87728a3b773cef0b7a88f32aa49182d415936b6127ea57ca7423403e606eba78" => :mojave
    sha256 "4f509c31a4881206ad637321fdb74c1e5eba0b239e4742d789e31f9f672814df" => :high_sierra
    sha256 "2b5842784cd73eb9f6a0c9ecb91860db9b08e9de060b77d23c968aee2953e594" => :sierra
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
