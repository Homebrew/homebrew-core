class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20181006001642.tar.gz"
  sha256 "07010999cc09a32e6c1eddfe44fcae12a294002bce1a667c00d1c9e65493b055"

  bottle do
    cellar :any_skip_relocation
    sha256 "e742c2d0b200ae0e438a0d89a8f1db626c96b970c0abd189962a217b320547b0" => :mojave
    sha256 "ca8f0f6e10698459eb28fc4d10416906f22a55e44e8583fb56a8521890fcc8b6" => :high_sierra
    sha256 "c88aea217fd2737a33f9f54769650f7872f15b6cdf0c4cbf0873b295e2e32afd" => :sierra
    sha256 "43476034581853e5a270ae8157fd8bd0e056d64999d545deb477d16fd405a53c" => :el_capitan
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
