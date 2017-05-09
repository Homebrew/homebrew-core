class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170508213441.tar.gz"
  sha256 "74860e3aff62449c0398c3c01cfd448857be35fd8bea4286ce657494331047d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b30f1129c4da3f18be33f6fee4822b9b35b459a168c8149ddbfa1ca6930c49c" => :sierra
    sha256 "f2def6c9664974eab4c2fe9d8924ab5dcdb96bb1f1c8ca5382e829be08ba4d6a" => :el_capitan
    sha256 "b435643e232ae86ee83e63560467517174332d429e142cff2915f4043b570884" => :yosemite
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
