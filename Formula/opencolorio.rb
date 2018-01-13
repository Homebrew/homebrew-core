class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "http://opencolorio.org/"
  url "https://github.com/imageworks/OpenColorIO/archive/v1.1.0.tar.gz"
  sha256 "228589879e1f11e455a555304007748a8904057088319ebbf172d9384b93c079"
  head "https://github.com/imageworks/OpenColorIO.git"

  bottle do
    cellar :any
    sha256 "daa76480e8a457e54c1526a1777def1ba59f10eab19a96be9dbf494ecfc54d3d" => :high_sierra
    sha256 "908cdf59c8eb2dd6afba51e1a851998ae551d5b9b885da66ade3e2c7cbce7447" => :sierra
    sha256 "e3a2312a3f21ea15255903f4b030d44fbcceee36e768a070427234d9b80a46fd" => :el_capitan
    sha256 "49edcb11a59fbcdbea875024a4c2719055fc17cee5e6472fe82d30e79685ae97" => :yosemite
    sha256 "8aba1648c2c21f1054956c2d0fa7884d3882e30446785419bc429e50022d242c" => :mavericks
  end

  option "with-test", "Verify the build with its unit tests (~1min)"
  option "with-java", "Build ocio with java bindings"
  option "with-docs", "Build the documentation"

  deprecated_option "with-tests" => "with-test"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on "python" => :optional

  def install
    args = std_cmake_args
    args << "-DOCIO_BUILD_JNIGLUE=ON" if build.with? "java"
    args << "-DOCIO_BUILD_TESTS=ON" if build.with? "test"
    args << "-DOCIO_BUILD_DOCS=ON" if build.with? "docs"
    args << "-DCMAKE_VERBOSE_MAKEFILE=OFF"

    # Python note:
    # OCIO's PyOpenColorIO.so doubles as a shared library. So it lives in lib, rather
    # than the usual HOMEBREW_PREFIX/lib/python2.7/site-packages per developer choice.
    args << "-DOCIO_BUILD_PYGLUE=OFF" if build.without? "python"

    args << ".."

    mkdir "macbuild" do
      system "cmake", *args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      OpenColorIO requires several environment variables to be set.
      You can source the following script in your shell-startup to do that:

          #{HOMEBREW_PREFIX}/share/ocio/setup_ocio.sh

      Alternatively the documentation describes what env-variables need set:

          http://opencolorio.org/installation.html#environment-variables

      You will require a config for OCIO to be useful. Sample configuration files
      and reference images can be found at:

          http://opencolorio.org/downloads.html
    EOS
  end

  test do
    assert_match "validate", shell_output("#{bin}/ociocheck --help", 1)
  end
end
