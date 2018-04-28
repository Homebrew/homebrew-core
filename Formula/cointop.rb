class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.0.1.tar.gz"
  sha256 "bb5450c734a2d0c54a1dc7d7f42be85eb2163c03e6d3dc1782d74b54a8cbfa69"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/miguelmota/cointop").install buildpath.children
    cd "src/github.com/miguelmota/cointop" do
      system "go", "build", "-o", "#{bin}/cointop"
      prefix.install_metafiles
    end
  end

  test do
    system "TERM=screen-256color #{bin}/cointop -test"
  end
end
