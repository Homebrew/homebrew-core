class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190918145319.tar.gz"
  sha256 "579b531a63d26bc445388a5bebcaf8774201c85df345153426d626d17351b487"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9b0d97a54e2d619a879426cdb4811ecd14da62608765edec9468d3cbcb3068e" => :mojave
    sha256 "4dfacf3fc7ba14bb7d196f0422acb723b6b0f441240a376c7fc8456ed7415b00" => :high_sierra
    sha256 "e9fecd043541f924bb4ef659b447af1799e157447cabbc0c27c4f155a9bcdb8b" => :sierra
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
