class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180507173314.tar.gz"
  sha256 "404d502250da12c4b4ef5280aeecd2f6908cb790f4f8b1743a98dfd13c3ccbdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "03461db1453cf0ee8e8ecacdd50c37e3f5509425031c0fd695f74b2ecc15a5f3" => :high_sierra
    sha256 "c6bc99c38e24524282b00225f9aa6be5faf538d5bc51aeb343aeadca6a71a504" => :sierra
    sha256 "d1c1400245798071c75c278a0e05323abf13bd7ee6860ed360a1e75366b45701" => :el_capitan
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
