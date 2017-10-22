class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171021214545.tar.gz"
  sha256 "a5634ace9baf1bf1d078cba02165b4a23bdcc509fa17405d8f84a3df2838eb98"

  bottle do
    cellar :any_skip_relocation
    sha256 "c92598b7af51df9cad04a2a147b37046afe9638b9863666ecc6c006c81e7d750" => :high_sierra
    sha256 "757f9cfaa6f56f4c844de018ac9c9d4a6bffb2118def55f06e3331caaed3c2e7" => :sierra
    sha256 "19d71de519fe19b70b3c8cc2ede0ebbebb9f6380cb3dd515977013b7d11287cd" => :el_capitan
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
