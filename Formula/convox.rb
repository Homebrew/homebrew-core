class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170918015908.tar.gz"
  sha256 "8a5fa2dcffc83fef7f10a65f9cb07989feadd42297cc69bfee91e679116eb48c"

  bottle do
    cellar :any_skip_relocation
    sha256 "4668cbbc9254d90f3830fc478b92c621b092148a8378208c5460a104cf465d40" => :sierra
    sha256 "12d66b68b55e464bb6aa5fe82058d9d7a9b26b2a664f55cd127f00d85d67bf66" => :el_capitan
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
