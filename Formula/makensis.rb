class Makensis < Formula
  desc "System to create Windows installers"
  homepage "https://nsis.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.07/nsis-3.07-src.tar.bz2"
  sha256 "4dfad3388589985b4cd91d20e18e1458aa31e7d139b5b8adf25c3a9c1015efba"
  license "Zlib"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b59325614e77c44159365a8539eedc26321f7fbefa85d93a3bb1088ad3fee817"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a677ad617fbb58ca25a087f0fbd1463c794796029dd244cb005698799ca83af"
    sha256 cellar: :any_skip_relocation, catalina:      "60ed29983ad57340f1eed7556a844bbb09781da190bd27bb16c59aeb5ba8a2b2"
    sha256 cellar: :any_skip_relocation, mojave:        "6295b3cfb71161a0642636a711a2ca2b691f2c0e317caaa014f17484eebfa603"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8aa50401f56ef67140d2538187216bb1af05483af0eb96494e82e7ce79cd1700"
  end

  depends_on "mingw-w64" => :build
  depends_on "scons" => :build

  uses_from_macos "zlib"

  resource "nsis" do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.07/nsis-3.07.zip"
    sha256 "04dde28896ae9ab36ea3035ff3a294e78053f00048064f6d22a6f1c02bcb6ec0"
  end

  def install
    args = [
      "CC=#{ENV.cc}",
      "CXX=#{ENV.cxx}",
      "PREFIX=#{prefix}",
      "PREFIX_DOC=#{share}/nsis/Docs",
      "SKIPUTILS=Makensisw,NSIS Menu,zip2exe",
      # Don't strip, see https://github.com/Homebrew/homebrew/issues/28718
      "STRIP=0",
      "VERSION=#{version}",
    ]
    args << "APPEND_LINKFLAGS=-Wl,-rpath,#{rpath}" if OS.linux?

    system "scons", "makensis", *args
    bin.install "build/urelease/makensis/makensis"
    (share/"nsis").install resource("nsis")
  end

  test do
    # Workaround for https://sourceforge.net/p/nsis/bugs/1165/
    ENV["LANG"] = "en_GB.UTF-8"
    %w[COLLATE CTYPE MESSAGES MONETARY NUMERIC TIME].each do |lc_var|
      ENV["LC_#{lc_var}"] = "en_GB.UTF-8"
    end

    system "#{bin}/makensis", "-VERSION"
    system "#{bin}/makensis", "#{share}/nsis/Examples/bigtest.nsi", "-XOutfile /dev/null"
  end
end
