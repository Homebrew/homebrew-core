class Hexgui < Formula
  desc "GUI for playing Hex over Hex Text Protocol"
  homepage "https://sourceforge.net/p/benzene/hexgui/"
  url "https://github.com/apetresc/hexgui/archive/v0.9.3.tar.gz"
  sha256 "e7bf9daebe39c4efb06d758c5634c6fa25e97031ffa98592c378af89a03e9e8d"
  license "GPL-3.0"
  head "https://github.com/apetresc/hexgui.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab36302c111ad3164f4746d80d937ec736f84967a90ee6cb8f9afc1f22e5f0dd" => :catalina
    sha256 "643b91090287bcafbd5aefcfd68c177580f22a2d179cb57bad865494cfc41c82" => :mojave
    sha256 "69dc43fc44aa2fbf83144c672aeb4e73b1471569fef39bdb20ee1653ea6c0c28" => :high_sierra
  end

  depends_on "ant" => :build
  depends_on java: "1.8"

  def install
    system "ant"
    libexec.install Dir["*"]
    (bin/"hexgui").write_env_script libexec/"bin/hexgui", Language::Java.java_home_env("1.8")
  end

  test do
    assert_match /^HexGui #{version} .*/, shell_output("#{bin}/hexgui -version").chomp
  end
end
