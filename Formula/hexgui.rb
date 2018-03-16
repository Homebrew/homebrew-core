class Hexgui < Formula
  desc "GUI for playing Hex over Hex Text Protocol"
  homepage "https://sourceforge.net/p/benzene/hexgui/"
  url "https://github.com/apetresc/hexgui/archive/v0.9.1.tar.gz"
  sha256 "7ed1af209617ad2e4877e5f46b4ba78eced14f94fa581b65ac3111abc7613c08"
  head "https://github.com/apetresc/hexgui.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cc22dcd291b736c4f3924282bffe306b80192ada7b52dca936d06080eef017a" => :high_sierra
    sha256 "9aa7e7d783c781df16193ce402675ffb5cd6d652a91fb52adc08f64e87949c30" => :sierra
    sha256 "6f3b7e06bd291e264d37d3d6d2118e34f8ce417d056a2b47d0a9a30add3c3491" => :el_capitan
    sha256 "d65b66b60e2aa05daf90732381b8f3778dfd66476f004a420c5a8ff2f7b6b0f3" => :yosemite
  end

  depends_on "ant" => :build
  depends_on :java => "1.6+"

  def install
    system "ant"
    libexec.install Dir["*"]
    (bin/"hexgui").write_env_script libexec/"bin/hexgui", Language::Java.java_home_env("1.6+")
  end

  test do
    assert_match /^HexGui #{version} .*/, shell_output("#{bin}/hexgui -version").chomp
  end
end
