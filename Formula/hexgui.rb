class Hexgui < Formula
  desc "GUI for playing Hex over Hex Text Protocol"
  homepage "https://sourceforge.net/p/benzene/hexgui/"
  url "https://github.com/apetresc/hexgui/archive/v0.9.1.tar.gz"
  sha256 "7ed1af209617ad2e4877e5f46b4ba78eced14f94fa581b65ac3111abc7613c08"
  head "https://github.com/apetresc/hexgui.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e87b126283782870c226f75fbb5afc11c2a67fba65531762de559bc41f543be" => :el_capitan
    sha256 "322cd3dbad1e2988391b03d54ffd33db5b75b5fdd5032121581c86c673fd43ca" => :yosemite
    sha256 "dd40606897e4153506c84c8fdac00d945774c1f5ac48ccbf70c2aedfbc2c2138" => :mavericks
  end

  depends_on :ant => :build
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
