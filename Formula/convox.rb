class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20160615213630.tar.gz"
  version "20160615213630"
  sha256 "f09b6adda368d67efa87b097299d9cdae1852d1a0c255f6740ff990f0064d937"

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
