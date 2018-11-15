class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.12.0.tar.gz"
  sha256 "9b4ffd65bfad2cf7e574f04db944f3b40d31fe76cc5cbd9bfb18ede5a07040ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8fd79db1b6151eac54746791ddc6db76892e1d7f90bb0174fa4ae260df18e11" => :mojave
    sha256 "86996e3fc014a2e6031159424873c83224bb3e62efc2fc21b619f2303fbb72ec" => :high_sierra
    sha256 "4863e713262fd431f04e4dca40aaa703ce19da57eff0116c7a2a217bb25471e2" => :sierra
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
