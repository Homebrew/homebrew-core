class Opencolorio < Formula
  desc "Color management solution geared towards motion picture production"
  homepage "http://opencolorio.org/"
  url "https://github.com/imageworks/OpenColorIO/archive/v1.1.0.tar.gz"
  sha256 "228589879e1f11e455a555304007748a8904057088319ebbf172d9384b93c079"
  head "https://github.com/imageworks/OpenColorIO.git"

  bottle do
    cellar :any
    sha256 "4025f926a9061c72ebbecf1b5bbcb23d27c0ba6d8e2f578deb4cea45c60f409c" => :high_sierra
    sha256 "18bf9288a4103a8f57f1869a884d3d1b697305e952eb977bd46f608d7d0695b3" => :sierra
    sha256 "9eac0c648be323730035b3885b376db665408f02290efa9dd1263655029a914f" => :el_capitan
  end

  option "with-test", "Verify the build with its unit tests (~1min)"
  option "with-docs", "Build the documentation"

  deprecated_option "with-tests" => "with-test"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "little-cms2"
  depends_on "python" => :optional

  def install
    args = std_cmake_args
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
