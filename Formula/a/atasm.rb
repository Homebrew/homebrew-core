class Atasm < Formula
  desc "Atari MAC/65 compatible assembler for Unix"
  homepage "https://sourceforge.net/projects/atasm/"
  url "https://github.com/CycoPH/atasm/archive/refs/tags/V1.30.tar.gz"
  sha256 "c3ae8ea1f824e0ee65e123b33982572277207d1749bcd04da3af8f06af977db5"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "729fb2476730654734f87152e0925af39a747afeda5a1d1719d74c0fb1b77b94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95d431fd1b13e5e3736ed4309f4ff2f8e8206cee0ace352d5353013429f0c0ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b61dcd891f38286d01f400a00b258eec3b684e7a2ea8d7c6fa1265a57acdeea"
    sha256 cellar: :any_skip_relocation, sonoma:        "2465fe4a6ff41737c651a8d9ea59bdfa1fe00842ec23373e43c6bb80371fee78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c55e4b9e3127a958e9925d8a7ec67ec21c410df64a6e1d9a1c15b1a048a20a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c9938e74e5a9bdd32cd294b8fa073eb27a13312fa6dec6027c346a5a2a42699"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      system bin/"atasm", "-v", "test.m65", "-o/tmp/test.bin"
    end
  end
end
