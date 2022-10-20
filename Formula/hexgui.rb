class Hexgui < Formula
  desc "GUI for playing Hex over Hex Text Protocol"
  homepage "https://sourceforge.net/p/benzene/hexgui/"
  url "https://github.com/apetresc/hexgui/archive/v0.9.3.tar.gz"
  sha256 "e7bf9daebe39c4efb06d758c5634c6fa25e97031ffa98592c378af89a03e9e8d"
  license "GPL-3.0"
  revision 2
  head "https://github.com/apetresc/hexgui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f149b8a959fc5ebcb74812f2a7a510ed6b2eb81e5dd4e2c38884227230f7d3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd232f1904e299ac277879e1336ed8c3bb79b74cdd52a54a45a3f8f28b319a1b"
    sha256 cellar: :any_skip_relocation, monterey:       "0bf896b0edea271ffc39eb6e88ce67f7a11af82fa4fc34300e0f683d62740cd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c97d11e9eb40d0d036fc47e824535fbd182a9929518413983d097ae069324161"
    sha256 cellar: :any_skip_relocation, catalina:       "208f0a509c18272214b091e415c3b79b936a7d225d003ffaf9d238247bf85b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cbd351ccc8565756b93c85d46d24d50387ec805911c52737bb8f7e804c0357f"
  end

  depends_on "ant" => :build
  depends_on "openjdk"

  def install
    system "ant"
    libexec.install Dir["*"]
    env = Language::Java.overridable_java_home_env
    env["PATH"] = "$JAVA_HOME/bin:$PATH"
    (bin/"hexgui").write_env_script libexec/"bin/hexgui", env
  end

  test do
    assert_match(/^HexGui #{version} .*/, shell_output("#{bin}/hexgui -version").chomp)
  end
end
