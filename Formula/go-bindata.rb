class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.9.0.tar.gz"
  sha256 "10589759b4c570af3e4db65ec2455faa07b5cd8e6a7229cabd3ddf5f117a5b65"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6a3970e196f9d27449fc9e02b7cfed083edff7e45e319317200e8de7eb20d12" => :high_sierra
    sha256 "2124a47bd5f58ecbd2d8ae097f2d9b79fd253e2bd15c57e05887d67b93630ec6" => :sierra
    sha256 "cc0a530da7a73c3d7875a1ae55050775c2c3c671a1c7b47576269ec53da14c70" => :el_capitan
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
