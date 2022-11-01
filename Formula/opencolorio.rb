class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/AcademySoftwareFoundation/OpenColorIO/archive/v2.2.0.tar.gz"
  sha256 "81e3b6e0e432d20347b6396c376f9fbeceac31c2cbefe2882d83112a5b0a8123"
  license "BSD-3-Clause"
  head "https://github.com/AcademySoftwareFoundation/OpenColorIO.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "957709fd186201808fd0fb870e98becb92c42fb645a7c7ac31e7d16ae424e365"
    sha256 cellar: :any,                 arm64_monterey: "78b68e78e504306bb3f9e1e7f5b8cdde8a413846de0799668e6bffe2e41bdf6c"
    sha256 cellar: :any,                 arm64_big_sur:  "ed7529684ebd94f754576862448163922998e1d5742c597ebc43a481703d618a"
    sha256 cellar: :any,                 monterey:       "179a32959944d37a8e48570b49e0e37967a0ffd61e92ffa41bcb4105395102be"
    sha256 cellar: :any,                 big_sur:        "10d9e4e650c38d401816cb56932b0925a9cd97b7a46eb19333329a8f5c9a0939"
    sha256 cellar: :any,                 catalina:       "fd01e301337285b2f305f26b96f15e289694ff14fa7a608783890a389c6b5313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa056459b6df29340ae669ef0d80603ce57a5a2c23d3276a9ee6cf2ce47edb7f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on "python@3.11"

  def install
    python3 = "python3.11"
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPYTHON=#{python3}
      -DPYTHON_EXECUTABLE=#{which(python3)}
    ]

    system "cmake", "-S", ".", "-B", "macbuild", *args, *std_cmake_args
    system "cmake", "--build", "macbuild"
    system "cmake", "--install", "macbuild"
  end

  def caveats
    <<~EOS
      OpenColorIO requires several environment variables to be set.
      You can source the following script in your shell-startup to do that:
        #{HOMEBREW_PREFIX}/share/ocio/setup_ocio.sh

      Alternatively the documentation describes what env-variables need set:
        https://opencolorio.org/installation.html#environment-variables

      You will require a config for OCIO to be useful. Sample configuration files
      and reference images can be found at:
        https://opencolorio.org/downloads.html
    EOS
  end

  test do
    assert_match "validate", shell_output("#{bin}/ociocheck --help", 1)
  end
end
