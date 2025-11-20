class Hexgui < Formula
  desc "GUI for playing Hex over Hex Text Protocol"
  homepage "https://sourceforge.net/p/benzene/hexgui/"
  url "https://github.com/apetresc/hexgui/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "902ebcdf46ac9b90fec6ebd2e24e8d12f2fb291ea4ef711abe407f13c4301eb8"
  license "GPL-3.0-or-later"
  head "https://github.com/apetresc/hexgui.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e0fa3feb12e15a8975ea760a3f4794e202ebf5a1c3268135aecd5e8f7174f518"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ccdb3e80a0eb41a92445f2eb7338c220303da8c6bd8e536e825d69b7fa2908a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37ccb0805ccbcc1a8a9af8ecb5c6b687ea896afeebb892029dfa07da395d5ad2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28d9d6d7ec542660e6760f7fbce2101b2259e096cd5ba57aaee7c39cd7399ba6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd4e9603173284cc9b7c066832fccc7e175f6bbad1b1e4fbee348fe658c1695a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67b948cd8592fa945919c0c3817e7fc4ef946c63f0eea2ce6eff0948a4d7b391"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b472541128e32ff7814d513e2bf85dc681dfc6c5266c8fa9822bbe2dc0c5f72"
    sha256 cellar: :any_skip_relocation, ventura:        "d8e8fd7679f0f5a55f8c2221049542ac4241c1c0ac3bbd2a05401bdf4b702401"
    sha256 cellar: :any_skip_relocation, monterey:       "d81898239d18db373e084173879a20bb068b5addb64e197cb89eea039aacd487"
    sha256 cellar: :any_skip_relocation, big_sur:        "604a0d381b523b54292f65b3e9ab20b3085e5a8f0c84065516c74bd38ce1245b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a23602aeb64e79dc0f28b3c7bf13a05144d2501d38804c5d000e0c7d8081acee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f3482e21058facf382c8920f29980679e4b168d2a5380ca9f995bb8e6383f4b"
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
