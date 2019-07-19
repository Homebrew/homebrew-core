class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190717145705.tar.gz"
  sha256 "7e1557f0284044e373bf094da1cd2465aa5aa0d1be3dc0941d072260977ea6f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb724fd59c71dacdd3db5a185fc70986f2fd9844d92ec054302579d7ed01ec9a" => :mojave
    sha256 "4aaa9ebdf022dabacd0c1014ca9c6ac75ff4d24a20cf21162eec4b092fa3c086" => :high_sierra
    sha256 "b6c4de767a7ccf313c98df5c8eb7d5a465fb8dd3426490e3ff438b5ff48d6f44" => :sierra
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
