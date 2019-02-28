class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.13.0.tar.gz"
  sha256 "16d23471f8b092d36261fc6b162e4cc30b245bf3b9c28b0f548788e6180a5729"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f658f7bf51973178850f15f87790eb0716bb53dc4bacb6f8069ae38fa8d5ab8" => :mojave
    sha256 "900dd65229d9a3206a0d5f60a528d4c55856d173fb2dac100ea38a69f34e9a4d" => :high_sierra
    sha256 "a7cc1bfa6da837775bcc95e04ff5a329d613ae13ffe77e87c1a8241fa15df8fe" => :sierra
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kevinburke").mkpath
    ln_s buildpath, buildpath/"src/github.com/kevinburke/go-bindata"
    system "go", "build", "-o", bin/"go-bindata", "./go-bindata"
  end

  test do
    (testpath/"data").write "hello world"
    system bin/"go-bindata", "-o", "data.go", "data"
    assert_predicate testpath/"data.go", :exist?
    assert_match '\xff\xff\x85\x11\x4a', (testpath/"data.go").read
  end
end
