class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.9.0.tar.gz"
  sha256 "10589759b4c570af3e4db65ec2455faa07b5cd8e6a7229cabd3ddf5f117a5b65"

  bottle do
    cellar :any_skip_relocation
    sha256 "69dad76e50df9b5936594b614cf8c30ddf558f1db951b5e45c1965ff89ab4800" => :high_sierra
    sha256 "3eebf1cb5f0d33008791e94c72f7a492b4f100f360f091f50945644ade52c34f" => :sierra
    sha256 "5aa096d3d2eea61df0f1e9f584698677821181593faf20bbf93fb549526c751f" => :el_capitan
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
