class Libmikmod < Formula
  desc "Portable sound library"
  homepage "http://mikmod.shlomifish.org"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.8/libmikmod-3.3.8.tar.gz"
  sha256 "4acf6634a477d8b95f18b55a3e2e76052c149e690d202484e8b0ac7589cf37a2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ec5f612dffeab778e8aaa78478a2157291b9e4a9f0601344123d5d421692023e" => :sierra
    sha256 "d4ab73d546746bec04cd6b46458457d5c8fb35244acc8289deaba2d27ea4d1aa" => :el_capitan
    sha256 "aa439fc42772f79091390244f084476def518280ba53699b8d540cfefa311778" => :yosemite
    sha256 "3bc07cf9d3295a6888ada8b508834246d26981e8f2935ac2d9847f7038c3f8c3" => :mavericks
  end

  option "with-debug", "Enable debugging symbols"
  option :universal

  def install
    ENV.O2 if build.with? "debug"
    ENV.universal_binary if build.universal?

    # OS X has CoreAudio, but ALSA is not for this OS nor is SAM9407 nor ULTRA.
    args = %W[
      --prefix=#{prefix}
      --disable-alsa
      --disable-sam9407
      --disable-ultra
    ]
    args << "--with-debug" if build.with? "debug"
    mkdir "macbuild" do
      system "../configure", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/libmikmod-config", "--version"
  end
end
