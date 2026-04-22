class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/refs/tags/v26.tar.gz"
  sha256 "c39feedaf44e01c89264fa169a68318897b85bd445fb2a11c0125f9729103e54"
  license "GPL-2.0-or-later"
  head "https://github.com/dubhater/vapoursynth-mvtools.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "406369000087292b5decc84727eaca52a88b83c99754744782203221fc522c6b"
    sha256 cellar: :any, arm64_sequoia: "b5caf19cef34a78c81d56f542d7ec191eea7ca072afdba53ea1c41d7e18eb92a"
    sha256 cellar: :any, arm64_sonoma:  "877060a2befc9c7ac6787a1591b223629fbd6fba33754933d46130b049f2d5f0"
    sha256 cellar: :any, sonoma:        "d3ad99631ccc7a67b718a13811cd1c6881888d9ddd3050d8d71e32a5674e098c"
    sha256               arm64_linux:   "6fca5e19f1687f108142e6988f216c0f066dbda83658707f5d0c45580b229429"
    sha256               x86_64_linux:  "af62856555e6280aff6df278c801d45545de453d70321829c85893fcc606a912"
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "fftw"
  depends_on "vapoursynth"

  def install
    # Replace vendored path to homebrew formula path
    inreplace "meson.build" do |s|
      s.gsub! "'vapoursynth/include'", "'#{Formula["vapoursynth"].opt_include}/vapoursynth'"
      s.gsub! "py.get_install_dir() / 'vapoursynth/plugins'", "'#{lib}'"
    end

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Create a symlink for the old library name for compatibility
    ln_sf lib/shared_library("mvtools"), lib/shared_library("libmvtools")
  end

  def caveats
    <<~EOS
      MVTools will not be autoloaded in your VapourSynth scripts. To use it
      use the following code in your scripts:

        vs.core.std.LoadPlugin(path="#{HOMEBREW_PREFIX}/lib/#{shared_library("libmvtools")}")
    EOS
  end

  test do
    script = <<~PYTHON.split("\n").join(";")
      import vapoursynth as vs
      vs.core.std.LoadPlugin(path="#{lib/shared_library("libmvtools")}")
    PYTHON
    python = Formula["vapoursynth"].deps
                                   .find { |d| d.name.match?(/^python@\d\.\d+$/) }
                                   .to_formula
                                   .opt_libexec/"bin/python"
    system python, "-c", script
  end
end
