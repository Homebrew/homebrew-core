class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/Mac%20OS%20X/Bit-Twist%202.0/bittwist-macosx-2.0.tar.gz"
  sha256 "8954462ac9e21376d9d24538018d1225ef19ddcddf9d27e0e37fe7597e408eaa"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44ef66f48c921f63ebb338f004360d50a256de44da0f13806fd15faccc37c5bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5cb0c91dbb06031ec0ed2f8ed21b7325423020f4aa949bcaebcc42d1c28a6f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32f0ed29ff9caa578d26286aec740330e6218cfe4c9ea2aa35df9587e90b9699"
    sha256 cellar: :any_skip_relocation, ventura:        "42ea2ae7460bf28b776942800df4b45770f886b86df7ac3e0f06595243d43553"
    sha256 cellar: :any_skip_relocation, monterey:       "7dbe86652afd954334c94a0c4c04603c1ddec179a03893d1462e89b24b7d2b06"
    sha256 cellar: :any_skip_relocation, big_sur:        "501f3df64c0991adb8be19bc835d4abc5277293de53206580ee9851ad36c23ce"
    sha256 cellar: :any_skip_relocation, catalina:       "784d96d15ae2ba653dcf4289cfbc58d16359e32bbb9e178a346d2dd6ee62c18a"
    sha256 cellar: :any_skip_relocation, mojave:         "5a282944a4d5c10caaea1217aa1b9e6225a2a5d8f5fb941bb3a77eed747cdc90"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b19dd7e9297e5f4d26472e93f1fc90bbe5c2b7d11cd18ab04606d3176d064fb7"
    sha256 cellar: :any_skip_relocation, sierra:         "b69084cc099ecb0fcea860d9d07fb8a271b1bd645bef603abfe0cb20f4979902"
    sha256 cellar: :any_skip_relocation, el_capitan:     "215b6353dcedd6ad0908e725c68204f2aa8413bf32ae3eb0a3afa96eb6c17d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "902f1bc2ee8dcf4eae6b9e4395dd72ec589d5f5267566073c7daf418b589baf4"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bittwist", "-help"
    system "#{bin}/bittwiste", "-help"
  end
end
