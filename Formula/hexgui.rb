class Hexgui < Formula
  desc "GUI for playing Hex over Hex Text Protocol"
  homepage "https://sourceforge.net/p/benzene/hexgui/"
  url "https://github.com/apetresc/hexgui/archive/v0.9.2.tar.gz"
  sha256 "8c4c808b72412e4f3d506921f21692ec63ed28a783179fbdee4eb19ed82fdeb8"
  head "https://github.com/apetresc/hexgui.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20bb6ef52823f04542d36a30fe287c434507dde7da65db8d6a2eaaca07182bff" => :catalina
    sha256 "fd20a0ef344f16b48caa919f9035fae68e581bf7f2513b550b1381b1ad50d9f0" => :mojave
    sha256 "01862818b35ba08d8c4f2d10242797b8ae60a6db4621dd53ce8b5fd41722dcc9" => :high_sierra
    sha256 "4021eba73364a966aff074205f33d5718ab9b51fc0ff6f4e7d5676d97439fb01" => :sierra
    sha256 "7be565ccc6959d4373fea52cb9fa0d23bc42039b1c8fb29fbe53a101f23685d7" => :el_capitan
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
