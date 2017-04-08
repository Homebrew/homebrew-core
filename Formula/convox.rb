class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170405220740.tar.gz"
  sha256 "5eb2995cd29650fd14bc815492242730b14cecc98c4695a43f10f909ce95aa9f"

  bottle do
    cellar :any_skip_relocation
    sha256 "17d9d5895b652148107d0acc7893e83d1d2ca406e0c67f0aff3a2fbc5cdb432e" => :sierra
    sha256 "622d147b91e846d9e5c6356f665ab7938b095bd1d3edacc18317208d8be2893c" => :el_capitan
    sha256 "0d139c0bcd8f785f996de8a13263b5d04c8ef6fd6ed04d99877d72b2547f282d" => :yosemite
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
