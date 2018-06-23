class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.0.6.tar.gz"
  sha256 "6188f21e7fcdfe686324a30a5ccc89a684e2a9acd81f2b042309ec0b28c26272"

  bottle do
    cellar :any_skip_relocation
    sha256 "665b0e10d72ad4b839865e1cb1a49cbf9b5a0df2a630957967b6542b884b5d4d" => :high_sierra
    sha256 "2f3ad7d0d3354630ab90c5241092af452e62f5c2a3ec9ccad6c03cf3e99dc232" => :sierra
    sha256 "c33295abaa7b47984059617f8490f92b06158744f16176aed1b3987a9791b164" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/miguelmota/cointop").install buildpath.children
    cd "src/github.com/miguelmota/cointop" do
      system "go", "build", "-o", bin/"cointop"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"cointop", "-test"
  end
end
