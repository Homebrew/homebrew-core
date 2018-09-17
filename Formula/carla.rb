class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v1.9.9.tar.gz"
  sha256 "13cff6febb0879190e4e8906f8cbb0e6a61ac1344cd8dbec0331598b59576548"

  bottle do
    sha256 "aaf263dfdcfd89676cfb9e2c5e8afad08425280350ef0586b49c7738cc9d9971" => :mojave
    sha256 "253d05aa4397a1066d66c0573e768ce537f8551e82e0f9873db75ee227ec7762" => :high_sierra
    sha256 "d7f8da23413a513676722920c2aa2855b8b89fda5a6a3a890c0d9dc065292a25" => :sierra
    sha256 "311941a8c4a5eb1b2b9104811ffc99ff6641fd22c1e689098f77e58ba34979a1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt"
  depends_on "python"

  def install
    args = []
    if ENV.compiler == :clang && MacOS.version <= :mountain_lion
      args << "MACOS_OLD=true"
    end

    system "make", *args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
