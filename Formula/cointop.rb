class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.0.0.tar.gz"
  sha256 "8ff6988cd18b35dbf85436add19135a587e03702b43744f563f137bb067f6e04"
  revision 1
  head "https://github.com/miguelmota/cointop.git"
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir "#{buildpath}/src/github.com/miguelmota/cointop"
    path = buildpath/"src/github.com/miguelmota/cointop"
    cd path do
      system "git", "clone", "https://github.com/miguelmota/cointop.git", "."
      system "go", "build", "-o", "#{bin}/cointop"
    end
  end

  test do
    system "true"
  end
end
