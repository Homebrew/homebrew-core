class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171109213549.tar.gz"
  sha256 "8865a083ff569ce5168b9e6879bc905a252c9b788c5e48ab554faccc72a186bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7deb4ad733b6f24f0524e7e8b49bee524c96930cdcd06a14f6e6b1ca34b4862" => :high_sierra
    sha256 "f299abe0b3c624576c082849ba7a8f8ed32a5684f405833b5bb61343aa9aa5e3" => :sierra
    sha256 "efa4660cad2a198bb90d244865ef8679d7b1bb76136f2eb93919578965ff3974" => :el_capitan
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
