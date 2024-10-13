class Nvtop < Formula
  desc "Interactive GPU process monitor"
  homepage "https://github.com/Syllo/nvtop"
  url "https://github.com/Syllo/nvtop/archive/refs/tags/3.1.0.tar.gz"
  sha256 "9481c45c136163574f1f16d87789859430bc90a1dc62f181b269b5edd92f01f3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cb9ecb47efcf979f89f7ffd79fbba0ba38182f628ef70b72bbb8def0fca761d6"
    sha256 cellar: :any,                 arm64_sonoma:   "a4595438adcf4878cea999a1770842d33b1d074e0b0cacb855214ea83fce61ce"
    sha256 cellar: :any,                 arm64_ventura:  "63cda3b0bc84ebf690e95ebb374734ab78466342f76811eb00907cad690fd580"
    sha256 cellar: :any,                 arm64_monterey: "13b4d754c45fd90233da5b8843111edecf21f933e2574b7c0dbc4ac437af873c"
    sha256 cellar: :any,                 sonoma:         "d6e99a21cc27e369de559bc2e3d77c580da551f93391b88d84f5ac97295cedd7"
    sha256 cellar: :any,                 ventura:        "e6f0713ea894a57940bce5a46ce67be0e2b847fdee7755e93df24b8d3ac01630"
    sha256 cellar: :any,                 monterey:       "c6b580790047c8d8c318c19875adb460f9f69578037e759d10aeefae74330f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb25616af225e2b98a84b068fe1ac38b9a7ae630caa0490259c9726338a4b28c"
  end

  depends_on "cmake" => :build
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libdrm"
    depends_on "systemd"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # nvtop is a TUI application
    assert_match version.to_s, shell_output("#{bin}/nvtop --version")
  end
end
