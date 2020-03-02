class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.18.0.tar.gz"
  sha256 "80f5fcad8e9b92e0fdb020e2f115b0208dadd05a8179f0d29c00a8e660731c3a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5b795a659029c16a6bf014e68ea530514c657c6e677ecfc84ee62dc191f98e8" => :catalina
    sha256 "99c8e1f3a136d933a123562c8f685b71b5670f548bfa35ef1f79c572e865f3cc" => :mojave
    sha256 "ea845e0b11f08c6b8ddfd1130a159329f23a127a6b909d02b529fa1a4828862d" => :high_sierra
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
