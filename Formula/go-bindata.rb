class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.7.0.tar.gz"
  sha256 "28553a1a1490465731484ac3326574f35c8528efc5ca7dcea428f8245f5c83b0"

  bottle do
    cellar :any_skip_relocation
    sha256 "af5e236506d60e05686858efdb7b4649b7c0e94ac905b2a348883811daed82fe" => :high_sierra
    sha256 "1e2fdfb1edf62dc81d79b2a382bef3539273aecf7c31dcd2ad25f25ba595691e" => :sierra
    sha256 "3d517d3e8a614ba91062c05bf171d6f29eab735e92cec4cd647260a49bdab5b5" => :el_capitan
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
