class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.0.3.tar.gz"
  sha256 "f11288672a1b31ec337658d401ecc982d9abb141386647e19769aaff66b8da77"

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
    pipe_output("DEV_IN=/dev/stderr DEV_OUT=/dev/stderr TERM=screen-256color #{bin}/cointop -test", nil, 0)
  end
end
