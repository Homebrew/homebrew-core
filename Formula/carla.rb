class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.4.1.tar.gz"
  sha256 "bbb188a672ea8871b11648d36770ba013497d03407ca9c73ed68429016f7536f"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d73c02d184d35358d663f45a067087c8b87547fce4c43a9d97059d69964b19bc"
    sha256 cellar: :any, big_sur:       "968987ce59da62af302c1820b05a165441a6cbb8aadf8e5de9055f1f8dba615b"
    sha256 cellar: :any, catalina:      "51e26ad503289b0241f695e9c1d3829b28ed569127168644c68c2b4dbde439ca"
    sha256 cellar: :any, mojave:        "bd7b6ed706d425e2c94a95060e837822b666586df658518025906a66ec2115dd"
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
