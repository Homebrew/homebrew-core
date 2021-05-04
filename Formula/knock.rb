class Knock < Formula
  desc "Port-knock server"
  homepage "https://zeroflux.org/projects/knock"
  url "https://zeroflux.org/proj/knock/files/knock-0.8.tar.gz"
  sha256 "698d8c965624ea2ecb1e3df4524ed05afe387f6d20ded1e8a231209ad48169c7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.zeroflux.org/projects/knock"
    regex(%r{The current version of knockd is <strong>v?(\d+(?:\.\d+)+)</strong>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c0bf14034959e6593ea34f7ceade85ddff2f9da1ad763c6245f6ab52d713985e"
    sha256 cellar: :any_skip_relocation, big_sur:       "c0ec091e5d5543653ab4edfd6aa2cb8a552d3b50bf0ebddf995dc6c650546e5c"
    sha256 cellar: :any_skip_relocation, catalina:      "d6d7e20fa46d9587c9e8f6f80cef047cb21997f9bd914f5999c02d345255e760"
    sha256 cellar: :any_skip_relocation, mojave:        "41badbc87fee76251158416bd506d8ee30e9997e673a64a57e5e039a8facb11e"
    sha256 cellar: :any_skip_relocation, high_sierra:   "06b02ba999daee09e6588a8edb4af78a41b8ab135ac1b618b4ab2b02b7646acf"
    sha256 cellar: :any_skip_relocation, sierra:        "5f29acd295f83fadd436423f61c58ad8a2682dd9f9a3f89740eeee1eb55c6373"
    sha256 cellar: :any_skip_relocation, el_capitan:    "030dc0a7c3ea623eb3d8e11374f744ad79f8aee8b7b75210f1a183b4d6d978de"
    sha256 cellar: :any_skip_relocation, yosemite:      "aac645d3c392386d99cb19200465a439639c8d3e7f8eac7021dbb677939cf155"
  end

  head do
    url "https://github.com/jvinet/knock.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "libpcap"

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
