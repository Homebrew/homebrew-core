class Cpulimit < Formula
  desc "CPU usage limiter"
  homepage "https://github.com/opsengine/cpulimit"
  url "https://github.com/opsengine/cpulimit/archive/v0.2.tar.gz"
  sha256 "64312f9ac569ddcadb615593cd002c94b76e93a0d4625d3ce1abb49e08e2c2da"
  license "GPL-2.0"
  head "https://github.com/opsengine/cpulimit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e94ecdb44d2b8f104510da469aaa27a879cbf41518c88315f346116203b9c944"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "993f9fe777c7feb2f2da49486e0b7febf6a6d822e64ff4f40f578ddc0f21d7f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f09919436a14d7b1598720ca832435b2500aebe0839f5055a253f52c59642a5d"
    sha256 cellar: :any_skip_relocation, ventura:        "e26ef5c56d8a24d533ebbe33a65dda99defac0f32504edff34358992b39fa1cb"
    sha256 cellar: :any_skip_relocation, monterey:       "71ef4e07ccd817edc04f0b60f0bdb2a4a2efa7acdb1fdbdf31216871cfe6b61c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3f394e17febb7af49a1cb35c46e33856263dc58016d959aad2d2a250aae1d7d"
    sha256 cellar: :any_skip_relocation, catalina:       "7330907348c0a181c75b069dba7ee628e8c524c9bb9510487dbfd43730173db5"
    sha256 cellar: :any_skip_relocation, mojave:         "b9c7f99cbc62eb7c02b19c63a9b7e3f9186175707ff853a7107447fd7b2ee249"
    sha256 cellar: :any_skip_relocation, high_sierra:    "077ab8835a3b44ce77e3b8bf867633115b1d056046b232e49aeac96ac30e731c"
    sha256 cellar: :any_skip_relocation, sierra:         "fa5bc8d713837693c6bbd6139bec5e48b8a1d46ef669b2e042715dd1318b1655"
    sha256 cellar: :any_skip_relocation, el_capitan:     "9d7320465152a12ba75ce924beada5a3ce365b14becaa75e08ee8334c2cb2f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e7b26fdf597d68a1f482095c11f606dc5fc6f88a27e88bf14a3e976cec0998a"
  end

  def install
    system "make"
    bin.install "src/cpulimit"
  end

  test do
    system "#{bin}/cpulimit", "--limit=10", "ls"
  end
end
