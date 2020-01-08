class Knock < Formula
  desc "Port-knock server"
  homepage "https://zeroflux.org/projects/knock"
  url "https://zeroflux.org/proj/knock/files/knock-0.7.tar.gz"
  sha256 "9938479c321066424f74c61f6bee46dfd355a828263dc89561a1ece3f56578a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6d7e20fa46d9587c9e8f6f80cef047cb21997f9bd914f5999c02d345255e760" => :catalina
    sha256 "41badbc87fee76251158416bd506d8ee30e9997e673a64a57e5e039a8facb11e" => :mojave
    sha256 "06b02ba999daee09e6588a8edb4af78a41b8ab135ac1b618b4ab2b02b7646acf" => :high_sierra
    sha256 "5f29acd295f83fadd436423f61c58ad8a2682dd9f9a3f89740eeee1eb55c6373" => :sierra
    sha256 "030dc0a7c3ea623eb3d8e11374f744ad79f8aee8b7b75210f1a183b4d6d978de" => :el_capitan
    sha256 "aac645d3c392386d99cb19200465a439639c8d3e7f8eac7021dbb677939cf155" => :yosemite
    sha256 "eb180c87d84707199ef6279a4709d76630a2089b331fb9ebc6c2bf58389fc921" => :mavericks
  end

  head do
    url "https://github.com/jvinet/knock.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "autoreconf", "-fi" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/knock", "localhost", "123:tcp"
  end
end
