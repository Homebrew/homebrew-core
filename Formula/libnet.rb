class Libnet < Formula
  desc "C library for creating IP packets"
  homepage "https://github.com/sam-github/libnet"
  url "https://github.com/libnet/libnet/releases/download/v1.2/libnet-1.2.tar.gz"
  sha256 "caa4868157d9e5f32e9c7eac9461efeff30cb28357f7f6bf07e73933fb4edaa7"

  bottle do
    cellar :any
    sha256 "0ecfbf2539a6e051ca8aa5962c0ee7cb57ffd173cf654b0eec8152c1a3fbf133" => :catalina
    sha256 "cadba638a54f4d5646a3510439ab89317ed23df3c45b12704b78065bb127fbc4" => :mojave
    sha256 "44e7b11e8f900f9d6f8e0d1a5deed99c46078dd2dbc997937f713ce5a1ac0f38" => :high_sierra
  end

  depends_on "doxygen" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
