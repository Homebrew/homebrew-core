class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.15.0.tar.gz"
  sha256 "f107d0c2979264239b80ac80755d656d09afdd59c02a231a68c7a71c6c9490e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbfad4635e3381cfb89d76fe4fecac2f0863a76f0d13250da7fd5172a92c621f" => :catalina
    sha256 "4761e92330aebdf7b802a140527ac4accd2ce4199ba872a7e1eecccca7a7eccc" => :mojave
    sha256 "aa3b01e62e79ea7bc66fa296dadda46b8c87e6177682855c6ae756ff76c5a7fc" => :high_sierra
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
