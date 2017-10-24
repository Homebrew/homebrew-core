class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171022123902.tar.gz"
  sha256 "cae0a90960d4bc12e5c9981e9398a69b04273d4b1085368f7f4dd3228a17652c"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1cfb8b8cf72ae55bd571dd86c9a205c5dc714d064d43232c09b61cb39525bef" => :high_sierra
    sha256 "965799cf5e4884afa5a089c2a4029fe673344787d6da3b2177a0f081a69f35bd" => :sierra
    sha256 "c9c312c8fb0032be17faeaaae22479ee1c6a10b87babcf4027561d3ca02361b4" => :el_capitan
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
