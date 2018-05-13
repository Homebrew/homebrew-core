class Cointop < Formula
  desc "Interactive terminal based UI application for tracking cryptocurrencies"
  homepage "https://cointop.sh"
  url "https://github.com/miguelmota/cointop/archive/1.0.4.tar.gz"
  sha256 "e5c9e7ad969252498d5e1c0f6861420e3a9871df85ed7c9d4d584c1ab548e31d"

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
    pipe_output("#{bin}/cointop -test", nil, 0)
  end
end
