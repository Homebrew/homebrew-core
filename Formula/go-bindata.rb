class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.14.0.tar.gz"
  sha256 "928672eec1f8b444c0621ab1a7e393f5cf78748748e7920a0ea2c7d5eeb4ffa5"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b1883fb733fdcbc5dbe34137629d0effcfbf66203ea6648240b99d0f3750c65" => :catalina
    sha256 "5d6dfcc495c30f74427d0b75ce42ffe6ba3918ab145c10017b4ffe0ea14ec278" => :mojave
    sha256 "e18623be0bc6bcc3ade188befa704ed1f3e88da0cb2450ab4564eadf1634bb74" => :high_sierra
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
