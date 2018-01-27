class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "http://krakend.io"
  url "https://github.com/devopsfaith/krakend-ce/archive/0.4.0.tar.gz"
  sha256 "c0e48b0e8234b1d7975c3dfa953f3c7568e4f1583c5ffb3fef95ee236a902afd"

  depends_on "go" => :build
  depends_on "dep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/devopsfaith/krakend-ce").install buildpath.children
    cd "src/github.com/devopsfaith/krakend-ce" do
      system "make", "deps"
      system "make", "build"
      bin.install "krakend"
    end
  end

  test do
    system "#{bin}/krakend", "--help"
  end
end
