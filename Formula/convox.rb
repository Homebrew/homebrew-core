class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190905141723.tar.gz"
  sha256 "2a308b69fcd2e0a7daf35b99b838b987432f73de63be2d5d5cb40bd1e4c5e87e"

  bottle do
    cellar :any_skip_relocation
    sha256 "e31a089d3f3bedc0e29f390f951f691058857c2258840d76cb1a1b25e59c62f0" => :mojave
    sha256 "57c39d488c2835599c39f93e4b45c83147031ba47370db22ee3172eeace060d2" => :high_sierra
    sha256 "b5ee911a364ff3bc2068bb14ae901dd7f44c8cc85b4933f130ced74f7611b998" => :sierra
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
