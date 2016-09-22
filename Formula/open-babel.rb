class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-2-4-0.tar.gz"
  version "2.4.0"
  sha256 "b210cc952ce1ecab6efaf76708d3bd179c9b0f0d73fe8bd1e0c934df7391a82a"
  head "https://github.com/openbabel/openbabel.git"

  bottle do
    sha256 "c83b5fb690526decabcb2add2a64454008c988a8ee47cbba0db7da324d948066" => :el_capitan
    sha256 "e632200d401723ed2f24181a785eb10234d2698a5d360f22356a13063bd46f0e" => :yosemite
    sha256 "4e18fbaba55efdc7a2f07743afeda5cb32d13ac987c1929968bef8ef16d3859b" => :mavericks
    sha256 "0350407844a4bbc86dbf0c6dd562ca6bac7b71b92251cfdf222a9f1d2a092306" => :mountain_lion
  end

  option "with-cairo", "Support PNG depiction"
  option "with-java", "Compile Java language bindings"
  option "with-python", "Compile Python language bindings"
  option "with-wxmac", "Build with GUI"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on python: :optional
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
