class Mvtools < Formula
  desc "Filters for motion estimation and compensation"
  homepage "https://github.com/dubhater/vapoursynth-mvtools"
  url "https://github.com/dubhater/vapoursynth-mvtools/archive/refs/tags/v27.tar.gz"
  sha256 "b3b93ae7243d91d058a2b101ca725b949350b3edf20c080a8735ab76993c9df8"
  license "GPL-2.0-or-later"
  head "https://github.com/dubhater/vapoursynth-mvtools.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "14809c01efd7e53351c96d8d1defba2a9325e547fa0db9036d1b6f16ac650f02"
    sha256 cellar: :any, arm64_sequoia: "a1b4a4b4db3ce08f36b2232cba673af8588b8c5a32d47b1c092a88040358e539"
    sha256 cellar: :any, arm64_sonoma:  "f6bfb7057960f5aa77cdbbd89acd1dcb97b22625e9dde04194d613796590d381"
    sha256 cellar: :any, sonoma:        "1c92246993863db2da8f4d30f40c1030a0431dc47386e26f43f583ebde716adc"
    sha256               arm64_linux:   "efe41d8791343d134a6951a75274e5714baff052ab75863455991ec5aa17fa0c"
    sha256               x86_64_linux:  "33c670e57b5f02ee2070c48438aea149d0d5162fd8b987e6fa91ea2e1a99f28a"
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
      s.gsub!(/^incdir = include_directories\(.*?^\)/m,
        "incdir = include_directories('#{Formula["vapoursynth"].opt_include}/vapoursynth')")
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
