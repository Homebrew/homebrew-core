class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/Mac%20OS%20X/Bit-Twist%202.0/bittwist-macosx-2.0.tar.gz"
  sha256 "8954462ac9e21376d9d24538018d1225ef19ddcddf9d27e0e37fe7597e408eaa"

  bottle do
    cellar :any_skip_relocation
    sha256 "784d96d15ae2ba653dcf4289cfbc58d16359e32bbb9e178a346d2dd6ee62c18a" => :catalina
    sha256 "5a282944a4d5c10caaea1217aa1b9e6225a2a5d8f5fb941bb3a77eed747cdc90" => :mojave
    sha256 "b19dd7e9297e5f4d26472e93f1fc90bbe5c2b7d11cd18ab04606d3176d064fb7" => :high_sierra
    sha256 "b69084cc099ecb0fcea860d9d07fb8a271b1bd645bef603abfe0cb20f4979902" => :sierra
    sha256 "215b6353dcedd6ad0908e725c68204f2aa8413bf32ae3eb0a3afa96eb6c17d60" => :el_capitan
    sha256 "279cade886758dfabfbaa319c6afb302c7e254db0377f0eed1f1155afb800175" => :yosemite
    sha256 "3dcd106243667b15b4be07203daffb1c97f815051734813c0e37384c6db3747c" => :mavericks
  end

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bittwist", "-help"
    system "#{bin}/bittwiste", "-help"
  end
end
