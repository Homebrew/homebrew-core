class Hexgui < Formula
  desc "GUI for playing Hex over Hex Text Protocol"
  homepage "https://sourceforge.net/p/benzene/hexgui/"
  url "https://github.com/apetresc/hexgui/archive/v0.9.3.tar.gz"
  sha256 "e7bf9daebe39c4efb06d758c5634c6fa25e97031ffa98592c378af89a03e9e8d"
  license "GPL-3.0"
  revision 1
  head "https://github.com/apetresc/hexgui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "44abaf6a475d74c93e8f986945bb5a455cfdf52ea40fd876b773b69b6b835a70"
    sha256 cellar: :any_skip_relocation, catalina: "70b804bf63f62c0aa4f98c5798f3353794b8c795c2f59300bf086a39ecd27b3b"
    sha256 cellar: :any_skip_relocation, mojave:   "3122e9db7ee36650e81a9ba6d6cd3b1844748e597389a830e66d85b2d0948243"
  end

  depends_on "ant" => :build
  depends_on arch: :x86_64 # openjdk@8 is not supported on ARM
  depends_on "openjdk@8"

  def install
    system "ant"
    libexec.install Dir["*"]
    (bin/"hexgui").write_env_script libexec/"bin/hexgui", Language::Java.java_home_env("1.8")
  end

  test do
    assert_match(/^HexGui #{version} .*/, shell_output("#{bin}/hexgui -version").chomp)
  end
end
