class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170712160322.tar.gz"
  sha256 "476d28bb1cc459ebed45895f6368cd177e8f989385961db5b13518ea8e0c1be3"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a4326600a2101ad87b02d84a37ff4dfb52f2a69ea124d75553b413faf3fe418" => :sierra
    sha256 "9713db52d11a0ce6f47f352eb6e05557a6335cf3079a88f9821fc6366d742fa9" => :el_capitan
    sha256 "15f860923891a039496dd72077f45ddc7654f9b4913538b3805951bd0ddeddbb" => :yosemite
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
