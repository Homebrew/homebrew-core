class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20160615213630.tar.gz"
  version "20160615213630"
  sha256 "f09b6adda368d67efa87b097299d9cdae1852d1a0c255f6740ff990f0064d937"

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
    system "go", "build", "-o", "#{bin}/convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system "#{bin}/convox"
  end
end
