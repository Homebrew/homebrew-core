class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-2-4-0.tar.gz"
  version "2.4.0"
  sha256 "b210cc952ce1ecab6efaf76708d3bd179c9b0f0d73fe8bd1e0c934df7391a82a"
  head "https://github.com/openbabel/openbabel.git"

  bottle do
    sha256 "3852d0fe38c854ac1f88f7e8dadaa227efcbbdbf8ac8b8dc60432ddb7f1cf201" => :sierra
    sha256 "ced3ef914169409f24c79c27721d8f1bbafe0cfa95bc645fb2acdeae2e2b27a3" => :el_capitan
    sha256 "0078ae5007d3d0bab51b2a032d627417bf12521fe7a52bffdb57222116e992a4" => :yosemite
  end

  option "with-cairo", "Support PNG depiction"
  option "with-java", "Compile Java language bindings"
  option "with-python", "Compile Python language bindings"
  option "with-wxmac", "Build with GUI"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on :python => :optional
  depends_on "wxmac" => :optional
  depends_on "cairo" => :optional
  depends_on "eigen"
  depends_on "swig" if build.with?("python") || build.with?("java")

  def install
    args = std_cmake_args
    args << "-DRUN_SWIG=ON" if build.with?("python") || build.with?("java")
    args << "-DJAVA_BINDINGS=ON" if build.with? "java"
    args << "-DBUILD_GUI=ON" if build.with? "wxmac"

    # Point cmake towards correct python
    if build.with? "python"
      pypref = `python -c 'import sys;print(sys.prefix)'`.strip
      pyinc = `python -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.strip
      args << "-DPYTHON_BINDINGS=ON"
      args << "-DPYTHON_INCLUDE_DIR='#{pyinc}'"
      args << "-DPYTHON_LIBRARY='#{pypref}/lib/libpython2.7.dylib'"
    end

    args << "-DCAIRO_LIBRARY:FILEPATH=" if build.without? "cairo"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats
    <<-EOS.undent
      Java libraries are installed to #{HOMEBREW_PREFIX}/lib so this path should be
      included in the CLASSPATH environment variable.
    EOS
  end

  test do
    system "#{bin}/obabel", "-:'C1=CC=CC=C1Br'", "-omol"
  end
end
