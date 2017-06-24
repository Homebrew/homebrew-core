class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170623170024.tar.gz"
  sha256 "d98db0bbcda3935eb7816aad214322a366eea7432a430263f2f12a3186be5063"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6620ebfc0f25705fc5cdd1513f2a2d3ce702301b9b6899afd7f28d5ec788ae1" => :sierra
    sha256 "f6c5f95069cf1590194581b88d67e4bf68fd2536ea1bb1304e207ddcb56bb505" => :el_capitan
    sha256 "9bbf0f8a67d6d457e34ff8edcada02e974e4048f190043b32488469c98c1de9c" => :yosemite
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
