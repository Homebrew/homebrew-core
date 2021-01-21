class Gnparser < Formula
  desc "Breaks biodiversity scientific names into their elements"
  homepage "https://github.com/gnames/gnparser"
  url "https://github.com/gnames/gnparser/archive/v1.0.1.tar.gz"
  sha256 "92f532c60cc325806c5c8bfd08590cf2905305a88f3d23eae395575fd281b67b"
  license "MIT"

  depends_on "go" => :build

  def install
    man1.install "man/gnparser.1"
    system "go", "build", *std_go_args, "./gnparser"
  end

  test do
    res = `#{bin}/gnparser -f compact "Bubo bubo L."`
    assert_match /"simple":"Bubo bubo"/, res
  end
end
