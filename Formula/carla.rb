class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.3.2.tar.gz"
  sha256 "9a4db68246705a52c1476bb81f4a8491c7d128ecc0bb5bde19b954afda1d10c6"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "607aaa3664b04728dc814a81abe09352f0f3af94fb5dd803723fe94284520b51"
    sha256 cellar: :any, big_sur:       "0809c746b91aead4266b9988081b71042e72698db0155a3893624184e4aff133"
    sha256 cellar: :any, catalina:      "e7151ffcf7023c25fb96a29394ae47d857388cb06b2d2b78298e02dcf7937fd6"
    sha256 cellar: :any, mojave:        "0b0b750258d5e714720dc017a2649694df1dcecbc25c662c9404f9e25d4ef57c"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.9"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.9"].opt_bin}/python3"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
