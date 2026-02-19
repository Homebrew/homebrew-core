class Ascii < Formula
  desc "List ASCII idiomatic names and octal/decimal code-point forms"
  homepage "http://www.catb.org/~esr/ascii/"
  url "https://gitlab.com/esr/ascii/-/archive/3.31/ascii-3.31.tar.bz2"
  sha256 "d2e4341eea4978a0728fae8fb614ca54622f695948816dc9e338144fe53dd53a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df19b44f0c1d073fe7fd893c145af3805304b00a30bdb2948471b1f3501dd493"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18bb145682367fdbd8fac9cb3d83ecba1faf86d37e1955e129ed0f2803bfbefb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eff2e8e46eb229c764c09168b40cd9915575fa143931ef6db7ab8037501d6fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "979bdd87914e7485aef39145e1c04d8d919b6977deb64d9519f00f3c4e52312b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17f477e3b3542c77f23f0b15515e1a8ed02bcc1ba918dd280b7738ac58f7781d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfa89d9135b4af9b0821a3c678a47d633d1c78705e1a77b8cf32d3d1e841145c"
  end

  depends_on "asciidoctor" => :build

  def install
    bin.mkpath
    man1.mkpath
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "Official name: Line Feed", shell_output("#{bin}/ascii 0x0a")
  end
end
