class Gowsdl < Formula
  desc "WSDL2Go code generation as well as its SOAP proxy"
  homepage "https://github.com/hooklift/gowsdl"
  url "https://github.com/hooklift/gowsdl.git",
      tag:      "v0.5.0",
      revision: "51f3ef6c0e8f41ed1bdccce4c04e86b6769da313"
  license "MPL-2.0"
  head "https://github.com/hooklift/gowsdl.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5a535d4229c19bc02619f84315d95580c19f84166c0a8f3d7b705484d9237fd4"
    sha256 cellar: :any_skip_relocation, big_sur:       "1651f1b4a5e360d71f2dd5aafb947810afec7b30e9a446bc21de460106266188"
    sha256 cellar: :any_skip_relocation, catalina:      "ac79869fae62091277dad289c73f337cee0c9d92a42b38af5dc4d59b53f59885"
    sha256 cellar: :any_skip_relocation, mojave:        "650f3a704f6918e069c60d64807ddffe3fd327b6ef2e5688768d08f646ccfa59"
    sha256 cellar: :any_skip_relocation, high_sierra:   "64d483de68fc8f23043ee9652addf1a918e79a3c68c70324652ab5d0ac4b1c64"
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
