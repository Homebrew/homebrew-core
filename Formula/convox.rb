class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171213132441.tar.gz"
  sha256 "5caceefce908b8091bd70ff2bac04b11a2a9e72b5e6c94af31093b7a32bbd00d"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ac1c7216e57faf3e736c2e186abe14151815a14f7a0a78911c40b486f8af7d0" => :high_sierra
    sha256 "3872004289c543bd3321eb886547b6f9b53feda75541ece8fb4599d23fd339a3" => :sierra
    sha256 "9f6d58b94e0c1abcf3a8b66df362315d8eef4ed2957e78d5c1a5472b2c3a9743" => :el_capitan
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
