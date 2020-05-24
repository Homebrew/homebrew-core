class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.21.0.tar.gz"
  sha256 "91ba0e1947c2c144d8834823b3ddd5b78b97391f912ae0d7a07b65bd468ac77d"

  bottle do
    cellar :any_skip_relocation
    sha256 "730bf3bbbbd6f38a4c7c27982a6b4b87ade8be2aed0bd698a5778813857496a7" => :catalina
    sha256 "d96ab41e1db02bd4a8ed7f181793d5c55e3929d5f37e946c269d99f19af6d8f6" => :mojave
    sha256 "0a1d4f6f849cf732d4afbc069c9dbcfd22f8a493a1707f1e1e4a6f68533eff91" => :high_sierra
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
