class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170515223736.tar.gz"
  sha256 "ad5c562a7da478cb6977a9069cd886e9b2da3a0a9d4518af67e78d82f4ca5301"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ab1e6ebfea0aa78611926ec96bf0fe4c4552f9e290100614fbe43c0b927296e" => :sierra
    sha256 "5ed38dc700ad1f4a60ed06dd41739da6d1148056046ef64274c9bb6b59a23991" => :el_capitan
    sha256 "e6822ba28ec408c2dc5f85a20176457c929dcfad37d65ca13ea54b6071413a8b" => :yosemite
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
