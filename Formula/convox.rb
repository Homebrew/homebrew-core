class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180405173234.tar.gz"
  sha256 "be46f53fb90f84f6c0f548bb04d95e453b10ec93236436a78e81663c6f158cdb"

  bottle do
    cellar :any_skip_relocation
    sha256 "566205c12f35ab7162a7cfd6bee1c93eae5d0f8e9a42fa8dcaad6be67e2fa48f" => :high_sierra
    sha256 "6a9e49d722ec3392e2ddecbea1655e4a571981753740fa9fde61e2e235a36bc5" => :sierra
    sha256 "c73a7c74e292e8bf6b6ebd8a9cac47caaf8edcaaed7afb7527eab837b644fb80" => :el_capitan
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
