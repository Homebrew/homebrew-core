class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "http://atari800.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/atari800/atari800/3.1.0/atari800-3.1.0.tar.gz"
  sha256 "901b02cce92ddb0b614f8034e6211f24cbfc2f8fb1c6581ba0097b1e68f91e0c"

  bottle do
    cellar :any
    sha256 "353f79b1bcffec963139639b6fba46df3b9bf950e8f0945c0e743a85863fac32" => :yosemite
    sha256 "91854011ad3614180c848105bd6461f9b37b490c9db7ccabc90a265be1ee6bf5" => :mavericks
    sha256 "32e0502feed7e38ed3047533b62c27262e7cec2f3c9007b8ba91ff1afcc19fce" => :mountain_lion
  end

  head do
    url "git://git.code.sf.net/p/atari800/source"
    depends_on "autoconf" => :build
  end

  depends_on "sdl"
  depends_on "libpng"

  def install
    chdir "src" do
      system "./autogen.sh" if build.head?
      system "./configure", "--prefix=#{prefix}",
                            "--disable-sdltest"
      system "make", "install"
    end
  end

  test do
    assert_equal "Atari 800 Emulator, Version #{version}",
                 shell_output("#{bin}/atari800 -v", 3).strip
  end
end
