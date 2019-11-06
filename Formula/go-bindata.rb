class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.16.0.tar.gz"
  sha256 "54e543314e1147e4c8b8d8b9ad48094189b28cb7bf48f7e7304e9616b29f77c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "12f47339543ad1c551f99d79afc4425aeccab732cc0a83628c80181994173227" => :catalina
    sha256 "7374ce827060b1d880bca4fa07816ab8d883f9eb63a36e11460966bcb68247ec" => :mojave
    sha256 "b727c8b6f4d036316a4429064f1a19fbcbdb6f3f4fcbe60a7549267eb66d7ab4" => :high_sierra
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
