class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/a607e53e5110b3ed3fd28bdc8e8c87a48f2e5b85.tar.gz"
  version "5"
  sha256 "0d624a5a2c71a59c91402e5759315d51ccaf92fc2ece1ab4244003b0e02c378a"

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    bin_path = buildpath/"src/github.com/gokcehan/lf"
    bin_path.install Dir["*"]
    cd bin_path do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"lf", "."
    end
  end

  test do
    system bin/"lf", "-doc"
  end
end
