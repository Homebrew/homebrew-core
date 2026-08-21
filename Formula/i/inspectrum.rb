class Inspectrum < Formula
  desc "Offline radio signal analyser"
  homepage "https://github.com/miek/inspectrum"
  url "https://github.com/miek/inspectrum/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "a11214070c0aa3379e6ffd1728aa9528bf1dd722b8b72218ea1b872471b50c65"
  license "GPL-3.0-or-later"
  head "https://github.com/miek/inspectrum.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c21e4520df7498e5a4e54bfad5930e87379dc94f359daa059399a58a7c52546"
    sha256 cellar: :any,                 arm64_sequoia: "2cbc4ecbe7531a6d91f495a71b0c133c729e381ee9930ec0fbaef5c39ee28c83"
    sha256 cellar: :any,                 arm64_sonoma:  "23dced3dffb32ada03c65c0cab098173142464cba27f26139bcaf5da21a21ff2"
    sha256 cellar: :any,                 sonoma:        "40f559efcf1c01153547a4621f5af92e555b8261aa328ed97ad0b66e34db568e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "529fdfe5ad6cef116d9d402b7b366b4158b83c490e1d6eb1083bcd7306e74c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdf31450cc84970bce45314f564dd15eced52aea0d8e3278569301dfb283abc7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "fftw"
  depends_on "liquid-dsp"
  depends_on "qtbase"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # inspectrum is a GUI application
    assert_match "-r, --rate <Hz>     Set sample rate.", shell_output("#{bin}/inspectrum -h").strip
  end
end
