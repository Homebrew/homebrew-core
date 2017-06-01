class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170531220422.tar.gz"
  sha256 "d501e4614ec82bd910fd3708085733236c5587a39f3e9bb0434460246557254b"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fb7815b2a3f11e630782a1aec23922959fad81b72e415cf3a366796e170c3fa" => :sierra
    sha256 "435d5fb5c480e0d861e8fe58f7a4102bfb72c01f883e208cd75652209f1e6480" => :el_capitan
    sha256 "7cf710b094bac9d56ea05dccb995f03a5de0f788e3eafcbf963d7cc4b491b253" => :yosemite
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
