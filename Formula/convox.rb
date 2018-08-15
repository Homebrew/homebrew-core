class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180815173013.tar.gz"
  sha256 "4ff5d487e964f94895a238b33c040605327b7887269b7eaf59ebdbecb4b32e7b"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "ce87ed84d040ab0e350ab97118dbadd12dbbc332e454c6d675565011fc4b49a3" => :high_sierra
    sha256 "db4b2a404533ec56cee16e9029e7958aede47dfea4a68a9e4cc9da6bf79b551f" => :sierra
    sha256 "f22c0d761dcb1680f2e876977e5930a51a450ff5863968df3273fbcbe063337c" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
    prefix.install_metafiles
  end

  test do
    system bin/"convox"
  end
end
