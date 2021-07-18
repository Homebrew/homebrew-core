class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.3.1.tar.gz"
  sha256 "b3c0aefbaf1112c9f6017b8681f6a3c3319b59a153e644800195f9552000fb98"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f67b0999935d63d99b9aad373e45fad9600b1bd9ecb0ceff9b77f22b8b6acdcd"
    sha256 cellar: :any, big_sur:       "284d9eb2d8c9fed6fa6f1a7158ee1887c7245d8b9dd042aa166796f122815007"
    sha256 cellar: :any, catalina:      "417e0ad0bfa4f252208367b5d0758ad4cbebd4dc31ef3582d9d308315c4ca211"
    sha256 cellar: :any, mojave:        "d7a922fec5b61c533fef45fd7f18d440dff2dda4767f125f6c8161dc98d918c0"
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
