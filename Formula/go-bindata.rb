class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.18.0.tar.gz"
  sha256 "80f5fcad8e9b92e0fdb020e2f115b0208dadd05a8179f0d29c00a8e660731c3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f857c11353080297c000d634710e6c26e1fe78660f3b8c75789a33afad6763e7" => :catalina
    sha256 "4251c415e1433e71f806dc5d76e52de3d88690cb499bf03906c84093014f40a4" => :mojave
    sha256 "dfcf19af928ea4dcd85111ff4540e8af4ed334bdeb6d568d63c7ba0ed0102eb6" => :high_sierra
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
