class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "https://opencolorio.org/"
  url "https://github.com/imageworks/OpenColorIO/archive/v1.1.1.tar.gz"
  sha256 "c9b5b9def907e1dafb29e37336b702fff22cc6306d445a13b1621b8a754c14c8"
  revision 1
  head "https://github.com/imageworks/OpenColorIO.git"

  bottle do
    cellar :any
    sha256 "f21ad137b2e3536ed54e05909e3d9b4ee1da8ec2acbe97e7dc5e0bc696735b52" => :mojave
    sha256 "6aa5426be3f5d36134c981eda604f81a89e9c88ad1ff93fc164a9726031c50b0" => :high_sierra
    sha256 "6a75c5efd60a5b6a5fba4f8ee1dbd2fba1f262026240d0fb97650f561ec878b6" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on "python"

  def install
    py3_config = `python3-config --configdir`.chomp
    py3_include = `python3 -c "import distutils.sysconfig as s; print(s.get_python_inc())"`.chomp
    py3_version = Language::Python.major_minor_version "python3"

    args = std_cmake_args + %W[
      -DCMAKE_VERBOSE_MAKEFILE=OFF
      -DPYTHON=python3
      -DPYTHON_EXECUTABLE=#{which "python3"}
      -DPYTHON_LIBRARY=#{py3_config}/libpython#{py3_version}.dylib
      -DPYTHON_INCLUDE_DIR=#{py3_include}
    ]

    mkdir "macbuild" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end
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
