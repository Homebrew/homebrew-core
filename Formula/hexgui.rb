class Hexgui < Formula
  desc "GUI for playing Hex over Hex Text Protocol"
  homepage "https://sourceforge.net/p/benzene/hexgui/"
  url "https://github.com/apetresc/hexgui/archive/v0.9.1.tar.gz"
  sha256 "7ed1af209617ad2e4877e5f46b4ba78eced14f94fa581b65ac3111abc7613c08"
  head "https://github.com/apetresc/hexgui.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "28ebbb4d02ce30c52cce946c83003779b9dd17d31cc8af13697ee784a641462f" => :high_sierra
    sha256 "a42e53240607300a36a09e6effb73597491ccfad44a8c6d004238ac72ccfd960" => :sierra
    sha256 "c9b7f2d9bc024be5b468e952e20ed25b2e779907998569e5065ad3cb5a472170" => :el_capitan
  end

  depends_on "ant" => :build
  depends_on :java => "1.8"

  def install
    system "ant"
    libexec.install Dir["*"]
    (bin/"hexgui").write_env_script libexec/"bin/hexgui", Language::Java.java_home_env("1.8")
  end

  test do
    assert_match /^HexGui #{version} .*/, shell_output("#{bin}/hexgui -version").chomp
  end
end
