class Gowsdl < Formula
  desc "WSDL2Go code generation as well as its SOAP proxy"
  homepage "https://github.com/hooklift/gowsdl"
  url "https://github.com/hooklift/gowsdl.git",
      :tag      => "v0.3.1",
      :revision => "2375731131398bde30666dc45b48cd92f937de98"
  head "https://github.com/hooklift/gowsdl.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5fd404e38c1b998c6984f06c4ac9cafe14003d532966b06c089fa6e769d11d67" => :catalina
    sha256 "b31f125e412680a97253faa4faf56b83f56fc3dc0ceec2eaca6bfdac5d2eb41a" => :mojave
    sha256 "4d2525b76e187e99b69b11237bd0bb5125559815b4041b177ced99eed0b87a8f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "build/gowsdl"
  end

  test do
    system "#{bin}/gowsdl"
  end
end
