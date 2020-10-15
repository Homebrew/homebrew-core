class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.21.0.tar.gz"
  sha256 "91ba0e1947c2c144d8834823b3ddd5b78b97391f912ae0d7a07b65bd468ac77d"
  license "BSD-2-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b83e2976473f2310d488db6c3b20c27c844ce0eae86d2787fb1f5081da7fc98" => :catalina
    sha256 "658b8c27208d0e31241c811ea52fde269354d79804e95db8fc6bf9b9dd5f89c5" => :mojave
    sha256 "e2c10e8a03c3393d7500bd085e2a9f36285ccd75cd38a989517c2aaba55f5586" => :high_sierra
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
