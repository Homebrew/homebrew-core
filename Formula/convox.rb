class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190318032544.tar.gz"
  sha256 "d0714b59b982219c0e112ac53bf249f207c8ab226d44141ce3217aa336f22d21"

  bottle do
    cellar :any_skip_relocation
    sha256 "568410e234667d4c976750815a74969b5df6e9479f7340d6077b557416c9cb25" => :mojave
    sha256 "e58d89f72671a200781a4413a90064696d4d7739a7a387a512096ea753745617" => :high_sierra
    sha256 "2ab8d4ad5e00f1e96b14c4d4d1cfef5abf4e31566859c2c8428748f1ff6fb47a" => :sierra
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
