class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.5.2.tar.gz"
  sha256 "e93c5d169538c991e1598c7de34a80f2e53af3cd063bb672fa020ba8e7dae140"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f6dad358a626999025a82f77b7195d6835e9102277013a1bce5b4b225a8b4e42"
    sha256 cellar: :any,                 arm64_big_sur:  "e3da612be57402a03736aa74aa3efa7eba0e84e4091e6ca7830e78618adf8389"
    sha256 cellar: :any,                 monterey:       "ec0ccdb10e58e6a0f5e71ac3bfbf87f7c65fc618aa749d1e1e25cd3d7d117cb7"
    sha256 cellar: :any,                 big_sur:        "d7e6a211d8e6da6f228b46ea769c905ec921822d968be921ddf8780ba3a39243"
    sha256 cellar: :any,                 catalina:       "2be72064c9de33b0971999b39e0e98c20cdb29752454538e8a8fd49078fbb61f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20e410ab2214739cef22ff9f4d787a81b4b4a7cbad595f908f814065334a51f2"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.10"

  fails_with gcc: "5"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.10"].opt_bin}/python3.10"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
