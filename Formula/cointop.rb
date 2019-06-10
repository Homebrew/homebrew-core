class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.3.0.tar.gz"
  sha256 "26eb1a8a33d63d88e8db4ed7c1112584c8432b9d53fc594c69cc8d7cd4cc7f79"

  bottle do
    cellar :any_skip_relocation
    sha256 "da568035975774ddc3dd1a7befb73d6fd00b6a33cfc98f6518bc35a336800423" => :mojave
    sha256 "54fdd02a0fb7f1455acc513fc4a8d68ee918652b85a993685ccb5f1ab87caa38" => :high_sierra
    sha256 "3e7a41b4dc133266c5b2d7e38bbf04eacc00643997bd53ed2f7d8ff730ba28e8" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/miguelmota/cointop"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", bin/"cointop"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cointop", "-test"
  end
end
