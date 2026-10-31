class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"
  url "https://gitlab.com/esr/ascii/-/archive/3.33/ascii-3.33.tar.bz2"
  sha256 "db92154ed708d88feef02440debe3a2011a2e7e77507f5698092722b15170a60"
  license "BSD-2-Clause"
  head "https://gitlab.com/esr/ascii.git", branch: "master"

  # The homepage links to the `stable` tarball but it can take longer than the
  # ten second livecheck timeout, so we check the Git tags as a workaround.
  livecheck do
    url :head
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("-", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d8ff81c36d2ca0159f5b630b5c58ea77a6b4a35055a393e8913d0560936e2b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83c6fc145da90e26255628385f2c71e40b984f99231535837f916bbf24771d15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c5afc0f5e4c7a97a66190bc53088517eae9336bc85fcb88e77abbd051e8476f7"
    sha256 cellar: :any,                 arm64_linux:       "e5e78243fbc43de8e1b3f1061d0cb5e7fc19998c04a9284380ce720d57b1f58b"
    sha256 cellar: :any,                 x86_64_linux:      "420cb39cb8aa5a9303e375a3e7e97304de06af839c23fed8075901c68afc8537"
  end

  depends_on "asciidoctor" => :build

  deny_network_access!

  def install
    bin.mkpath
    man1.mkpath
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Official name: Line Feed", shell_output("#{bin}/ascii 0x0a")
  end
end
