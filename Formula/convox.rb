class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171213132441.tar.gz"
  sha256 "5caceefce908b8091bd70ff2bac04b11a2a9e72b5e6c94af31093b7a32bbd00d"

  bottle do
    cellar :any_skip_relocation
    sha256 "360d5b9e7a931eb952601428d01e4110489e5bdcc4dc7d72f1b61c15b7516a48" => :high_sierra
    sha256 "3711baf7e446a01de2fe6df35cf60acaad22a797be864ba353706224b63fe3cc" => :sierra
    sha256 "16d801f1101cdc9e515db52f03f3a71d322cf380ac89ccbb0e47ad2b534c22df" => :el_capitan
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
