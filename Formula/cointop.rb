class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.0.2.tar.gz"
  sha256 "81d44366284106c56e58f53c58644c65f42cab94469db4f4f1f726f20385c432"

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
    ln_s "/dev/stderr", "/dev/tty"
    pipe_output("DEV_IN=/dev/stdout DEV_OUT=/dev/stdout TERM=screen-256color #{bin}/cointop -test", nil, 0)
  end
end
