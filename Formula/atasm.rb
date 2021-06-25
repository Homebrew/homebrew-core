class Atasm < Formula
  desc "Atari MAC/65 compatible assembler for Unix"
  homepage "https://atari.miribilist.com/atasm/"
  url "https://atari.miribilist.com/atasm/atasm109.zip"
  version "1.09"
  sha256 "dbab21870dabdf419920fcfa4b5adfe9d38b291a60a4bc2ba824595f7fbc3ef0"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://atari.miribilist.com/atasm/VERSION.TXT"
    regex(/  version (\d+(?:\.\d+)+) /i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5e039ac5553f6b2dc4e02871041ce1cc7fb4030f90d6601c381ff3060f9c8f2a"
    sha256 cellar: :any_skip_relocation, big_sur:       "88e14d4779b2bd0437988d9525b5a5f7cca8ce76334bc89780a19acb539de225"
    sha256 cellar: :any_skip_relocation, catalina:      "8f142806b05036e541ef3fec3009d481423f451cbcd99e6be68ae5095cfa205e"
    sha256 cellar: :any_skip_relocation, mojave:        "7a2437b5a0adf8047fc75a20fb669d2d80b15d261eab0ec0ad5c7d74b9123a2b"
    sha256 cellar: :any_skip_relocation, high_sierra:   "b9eb26201949590ab8fce80ee3feabe7f0be2f611e7c60b6b456c8d78480680c"
  end

  uses_from_macos "zlib"

  def install
    cd "src" do
      system "make"
      bin.install "atasm"
      inreplace "atasm.1.in", "%%DOCDIR%%", "#{HOMEBREW_PREFIX}/share/doc/atasm"
      man1.install "atasm.1.in" => "atasm.1"
    end
    doc.install "examples", Dir["docs/atasm.*"]
  end

  test do
    cd "#{doc}/examples" do
      system "#{bin}/atasm", "-v", "test.m65", "-o/tmp/test.bin"
    end
  end
end
