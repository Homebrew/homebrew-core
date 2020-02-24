class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.17.0.tar.gz"
  sha256 "e44827c0845a1ce31dde7c28f16625bc1788d835c44343558359e2eb8200dab5"

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
