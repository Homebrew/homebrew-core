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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "727eea7c68b8de0a001e3b0937c429af8797af568433be534d74ada42a1925eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fab0b76cba3104965e4627681e2f5776df2337ad3300ba6acf140a0151afe237"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4c812d6e1cc7f0b02d3c00160d7656779fe163f62c55da63ae2359bc472585b"
    sha256 cellar: :any_skip_relocation, ventura:        "516c1388cf1e4c11c805dd8f9670b53be3ee63469b0d4804c24917b5cba18432"
    sha256 cellar: :any_skip_relocation, monterey:       "16ea6c4cd36ace328c78bbe3daeaad7e22ea30c5e013b07584eb00e9931ef67e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d7eba0c0fa5194201d4fac69466c807bf01d3676424a1501d3bc35cec2e43c1"
    sha256 cellar: :any_skip_relocation, catalina:       "d89f9e6ccd622ec72be4e8c3e5c01fa1b70abc1cf79b8cd5379ff986aae6d616"
    sha256 cellar: :any_skip_relocation, mojave:         "0f123b8ac337d96f5f528bdcd31fdd44b1cde57227c5f3451b83a15918b5cc79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d348c1f0f46cb7d43078b336c4b08751966d9763f4ce3470aa082f94a1ed90e1"
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
