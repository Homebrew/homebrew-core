class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20160623185456.tar.gz"
  sha256 "0ff842a5ac3d21f8b3b7d40b36f6286e389ccebfb3befdf6786c0bf808c09e13"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3404b9a9c2b2074b894dea38a1d6835c50325bccf4f26b51f09675f80fbc7c4" => :el_capitan
    sha256 "c4704b42a0122fea18642f43fac7ac3a38a242843de5990a329ae676f642beaf" => :yosemite
    sha256 "3a6a20d1b08d324e07ceb920023c6e8b80bebd0ac894e7d32db00182f1d94002" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}", "-o", "#{bin}/convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system "#{bin}/convox"
  end
end
