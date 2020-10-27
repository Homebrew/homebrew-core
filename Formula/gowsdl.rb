class Gowsdl < Formula
  desc "WSDL2Go code generation as well as its SOAP proxy"
  homepage "https://github.com/hooklift/gowsdl"
  url "https://github.com/hooklift/gowsdl.git",
      tag:      "v0.4.0",
      revision: "7a3e6bce010b32c1672884a6d478a16fee8f2d05"
  license "MPL-2.0"
  head "https://github.com/hooklift/gowsdl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac79869fae62091277dad289c73f337cee0c9d92a42b38af5dc4d59b53f59885" => :catalina
    sha256 "650f3a704f6918e069c60d64807ddffe3fd327b6ef2e5688768d08f646ccfa59" => :mojave
    sha256 "64d483de68fc8f23043ee9652addf1a918e79a3c68c70324652ab5d0ac4b1c64" => :high_sierra
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
