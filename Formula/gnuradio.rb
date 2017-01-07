class Gnuradio < Formula
  desc "SDK providing the signal processing runtime and processing blocks"
  homepage "https://gnuradio.squarespace.com/"
  url "https://gnuradio.org/releases/gnuradio/gnuradio-3.7.10.1.tar.gz"
  sha256 "63d7b65cc4abe22f47b8f41caaf7370a0a502b91e36e29901ba03e8838ab4937"

  bottle do
    sha256 "7f2b54d889d4d568736e9ae8221b0a652015d6abb18b1466a5637f92a007884f" => :sierra
    sha256 "7b70a05aeeb12d4457c81093880786468210d8dc1a409bc1181d6910607e3b3f" => :el_capitan
    sha256 "464555aaac52b55b9e09ec2b0b2e0e4cabc024b655a1bf815d7ddde59aec92fe" => :yosemite
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "boost"
  depends_on "cppunit"
  depends_on "fftw"
  depends_on "gsl"
  depends_on "zeromq"

  # For documentation
  depends_on "doxygen" => :build
  depends_on "sphinx-doc" => :build

  depends_on "uhd" => :recommended
  depends_on "sdl" => :recommended
  depends_on "jack" => :recommended
  depends_on "portaudio" => :recommended

  # gnuradio is known not to compile against CMake >3.3.2 currently.
  #resource "cmake" do
  #  url "https://cmake.org/files/v3.3/cmake-3.3.2.tar.gz"
  #  sha256 "e75a178d6ebf182b048ebfe6e0657c49f0dc109779170bad7ffcb17463f2fc22"
  #end

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.10.1.tar.gz"
    sha256 "8b9f453f29ce96a14e625100d3dcf8926301d36c5f622623bf8820e748510858"
  end

  # cheetah starts here
  resource "Markdown" do
    url "https://pypi.python.org/packages/source/M/Markdown/Markdown-2.4.tar.gz"
    sha256 "b8370fce4fbcd6b68b6b36c0fb0f4ec24d6ba37ea22988740f4701536611f1ae"
  end

  resource "Cheetah" do
    url "https://pypi.python.org/packages/source/C/Cheetah/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end
  # cheetah ends here

  resource "lxml" do
    url "https://pypi.python.org/packages/source/l/lxml/lxml-2.0.tar.gz"
    sha256 "062e6dbebcbe738eaa6e6298fe38b1ddf355dbe67a9f76c67a79fcef67468c5b"
  end

  resource "cppzmq" do
    url "https://github.com/zeromq/cppzmq/raw/a4459abdd1d70fd980f9c166d73da71fe9762e0b/zmq.hpp"
    sha256 "f042d4d66e2a58bd951a3eaf108303e862fad2975693bebf493931df9cd251a5"
  end

  def install
    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

#    resource("cmake").stage do
#      args = %W[
#        --prefix=#{buildpath}/cmake
#        --no-system-libs
#        --parallel=#{ENV.make_jobs}
#        --datadir=/share/cmake
#        --docdir=/share/doc/cmake
#        --mandir=/share/man
#        --system-zlib
#        --system-bzip2
#      ]
#
#      # https://github.com/Homebrew/homebrew/issues/45989
#      if MacOS.version <= :lion
#        args << "--no-system-curl"
#      else
#        args << "--system-curl"
#      end
#
#      system "./bootstrap", *args
#      system "make"
#      system "make", "install"
#    end

    ENV.prepend_path "PATH", buildpath/"cmake/bin"

    res = %w[Markdown Cheetah lxml numpy]
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    resource("cppzmq").stage include.to_s

    args = std_cmake_args

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    args << "-DENABLE_DEFAULT=OFF"
    enabled_components = %w[gr-analog gr-fft volk gr-filter gnuradio-runtime
                            gr-blocks testing gr-pager gr-noaa gr-channels
                            gr-audio gr-fcd gr-vocoder gr-fec gr-digital
                            gr-dtv gr-atsc gr-trellis gr-zeromq]
    enabled_components << "gr-wavelet"
    enabled_components << "gr-video-sdl" if build.with? "sdl"
    enabled_components << "gr-uhd" if build.with? "uhd"
    enabled_components += %w[doxygen sphinx] if build.with? "documentation"

    enabled_components.each do |c|
      args << "-DENABLE_#{c.upcase.split("-").join("_")}=ON"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    rm bin.children.reject(&:executable?)
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnuradio-config-info -v").chomp
  end
end
