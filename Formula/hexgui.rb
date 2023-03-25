class Hexgui < Formula
  desc "GUI for playing Hex over Hex Text Protocol"
  homepage "https://sourceforge.net/p/benzene/hexgui/"
  url "https://github.com/apetresc/hexgui/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "902ebcdf46ac9b90fec6ebd2e24e8d12f2fb291ea4ef711abe407f13c4301eb8"
  license "GPL-3.0-or-later"
  head "https://github.com/apetresc/hexgui.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a8c3b10c268fd780f0f29ed33e89ec46bee8ca8a5732024d378171a0ba88c9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "982759e2c16c75e166f420fad5d05c2a4a2ee5a376d50ed840e534205cd57bb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cbc67d8f62272f043cc9c141ad8bdacd82ae60c8c804570e9ce1b8315cd2777"
    sha256 cellar: :any_skip_relocation, ventura:        "fe877b232747acc39aa34dc044d37147ed088122761c506c3c5573507c0b0c34"
    sha256 cellar: :any_skip_relocation, monterey:       "74d56724b46e6ba13000a4d422591076feb7f8034a04f6dad16f43a52006e23c"
    sha256 cellar: :any_skip_relocation, big_sur:        "de3d1882c2e6c01233169d3e346f2c8f044ea3c91f4431ec594d5356f31014ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2a426caf77e7ce888641b2eec2a4112b491bc15c6997bf19bd4a4c3897a0e9c"
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
