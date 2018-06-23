class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.0.6.tar.gz"
  sha256 "6188f21e7fcdfe686324a30a5ccc89a684e2a9acd81f2b042309ec0b28c26272"

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
    system "#{bin}/cointop", "-test"
  end
end
