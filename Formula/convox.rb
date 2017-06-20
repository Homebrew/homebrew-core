class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170614131937.tar.gz"
  sha256 "f69576d4a5dcc24743e612696cf5062fc935edca7296e1c4eb0ac825c35637d6"

  bottle do
    cellar :any_skip_relocation
    sha256 "f37e59558545eee0ef8e680433d33d1cf85235136d8fc266dd0d30f0342cb67f" => :sierra
    sha256 "d4830b75140cb6139eb0080c40f7fcc056977c32ae0dd55fbac131f740a3f36f" => :el_capitan
    sha256 "d6a5c96c3b18bd8a5187980718ba8b85ca98dce38dd8830a64a07257d8e07b26" => :yosemite
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
