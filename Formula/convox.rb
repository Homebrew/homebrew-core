class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180719231503.tar.gz"
  sha256 "f16e24ac35a60235ca2ad555ec839e76da225cb136aa9a98c18b7ce503268c83"

  bottle do
    cellar :any_skip_relocation
    sha256 "30011ec82c21029f86b972bc8dfaf31ae59dfe0c6f3e5c623f2f74432680c144" => :high_sierra
    sha256 "ef425cf10d05dde247a3febfdbe18a636fadb53816e076de70fc0c3383771edd" => :sierra
    sha256 "36ffb483f3859a945c8aeedc5205f8db4930544737c05977c602166d860629d2" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system bin/"convox"
  end
end
