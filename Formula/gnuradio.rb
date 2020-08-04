class Gnuradio < Formula
  include Language::Python::Virtualenv

  desc "SDK providing the signal processing runtime and processing blocks"
  homepage "https://gnuradio.org/"
  url "https://github.com/gnuradio/gnuradio/releases/download/v3.8.1.0/gnuradio-3.8.1.0.tar.gz"
  sha256 "e15311e7da9fe2bb790cc36321d7eb2d93b9dfa0c1552fa5d534dd99d22873be"
  license "GPL-3.0"
  head "https://github.com/gnuradio/gnuradio.git"

  bottle do
    sha256 "c7c36be5693fb71d05af477df025343789b14d0414602cefd16ad9ccabfd3496" => :catalina
    sha256 "0c180f3fb648740043a5add826ed0df532114bacf313455d7c1c48e9e8ef6a85" => :mojave
    sha256 "23f47312eefc8be65640b1af2c49e32eaf04d19535e561465602d91ba83949f0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "fftw"
  depends_on "gmp"
  depends_on "gsl"
  depends_on "log4cpp"
  depends_on "numpy"
  depends_on "portaudio"
  depends_on "pyqt"
  depends_on "python@3.8"
  depends_on "qt"
  depends_on "uhd"
  depends_on "zeromq"

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/4e/72/e6a7d92279e3551db1b68fd336fd7a6e3d2f2ec742bf486486e6150d77d2/Cheetah3-3.2.4.tar.gz"
    sha256 "caabb9c22961a3413ac85cd1e5525ec9ca80daeba6555f4f60802b6c256e252b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/b0/3c/8dcd6883d009f7cae0f3157fb53e9afb05a0d3d33b3db1268ec2e6f4a56b/Mako-1.1.0.tar.gz"
    sha256 "a36919599a9b7dc5d86a7a8988f23a9a3a3d083070023bab23d64f7f1d1e0a4b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/e3/e8/b3212641ee2718d556df0f23f78de8303f068fe29cdaa7a91018849582fe/PyYAML-5.1.2.tar.gz"
    sha256 "01adf0b6c6f61bd11af6e10ca52b7d4057dd0be0343eb9283c878cf3af56aee4"
  end

  resource "cppzmq" do
    url "https://raw.githubusercontent.com/zeromq/cppzmq/46fc0572c5e9f09a32a23d6f22fd79b841f77e00/zmq.hpp"
    sha256 "964031c0944f913933f55ad1610938105a6657a69d1ac5a6dd50e16a679104d5"
  end

  # patch for boost 1.73.0, remove after next release
  # https://github.com/gnuradio/gnuradio/pull/3566
  patch do
    url "https://github.com/gnuradio/gnuradio/commit/5752be31d17be80203d9fc44a73661712542bfe1.patch?full_index=1"
    sha256 "8e50a04dbe12accd133a9db7d3bde6d704e805ae4f6acf734182608e306975d6"
  end

  # Add -undefined dynamic_lookup linker flag back for macOS
  # https://github.com/gnuradio/gnuradio/pull/3674
  patch do
    url "https://github.com/gnuradio/gnuradio/commit/80ba62cb11cf604495e87a5e302e68eaf441eea9.patch?full_index=1"
    sha256 "d12640f62b266b244950d84f2deb1544f41574229106a525e693159fb3fc80eb"
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["qt"].opt_bin.to_s

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    venv_root = libexec/"venv"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", "#{venv_root}/lib/python#{xy}/site-packages"
    venv = virtualenv_create(venv_root, "python3")

    %w[Mako six Cheetah PyYAML click click-plugins].each do |r|
      venv.pip_install resource(r)
    end

    # Avoid references to the Homebrew shims directory
    inreplace ["CMakeLists.txt", "volk/lib/CMakeLists.txt"] do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    resource("cppzmq").stage include.to_s

    args = std_cmake_args + %W[
      -DGR_PKG_CONF_DIR=#{etc}/gnuradio/conf.d
      -DGR_PREFSDIR=#{etc}/gnuradio/conf.d
      -DENABLE_DEFAULT=OFF
      -DPYTHON_EXECUTABLE=#{venv_root}/bin/python
      -DPYTHON_VERSION_MAJOR=3
      -DCMAKE_PREFIX_PATH=#{Formula["qt"].opt_lib}
      -DQT_BINARY_DIR=#{Formula["qt"].opt_bin}
      -DENABLE_TESTING=OFF
    ]

    enabled = %w[GNURADIO_RUNTIME GR_ANALOG GR_AUDIO GR_BLOCKS
                 GR_CHANNELS GR_DIGITAL GR_DTV GR_FEC GR_FFT GR_FILTER
                 GR_MODTOOL GR_TRELLIS GR_UHD GR_UTILS GR_VOCODER GR_WAVELET
                 GR_ZEROMQ PYTHON VOLK]
    enabled.each do |c|
      args << "-DENABLE_#{c}=ON"
    end
    args << "-DENABLE_GRC=OFF"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    mv Dir[lib/"python#{xy}/dist-packages/*"], lib/"python#{xy}/site-packages/"
    rm_rf lib/"python#{xy}/dist-packages"

    site_packages = lib/"python#{xy}/site-packages"
    pth_contents = "import site; site.addsitedir('#{site_packages}')\n"
    (venv_root/"lib/python#{xy}/site-packages/homebrew-gnuradio.pth").write pth_contents

    rm bin.children.reject(&:executable?)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnuradio-config-info -v")

    (testpath/"test.c++").write <<~EOS
      #include <gnuradio/top_block.h>
      #include <gnuradio/blocks/null_source.h>
      #include <gnuradio/blocks/null_sink.h>
      #include <gnuradio/blocks/head.h>
      #include <gnuradio/gr_complex.h>

      class top_block : public gr::top_block {
      public:
        top_block();
      private:
        gr::blocks::null_source::sptr null_source;
        gr::blocks::null_sink::sptr null_sink;
        gr::blocks::head::sptr head;
      };

      top_block::top_block() : gr::top_block("Top block") {
        long s = sizeof(gr_complex);
        null_source = gr::blocks::null_source::make(s);
        null_sink = gr::blocks::null_sink::make(s);
        head = gr::blocks::head::make(s, 1024);
        connect(null_source, 0, head, 0);
        connect(head, 0, null_sink, 0);
      }

      int main(int argc, char **argv) {
        top_block top;
        top.run();
      }
    EOS
    system ENV.cxx, "-std=c++11", "-L#{lib}", "-L#{Formula["boost"].opt_lib}",
           "-lgnuradio-blocks", "-lgnuradio-runtime", "-lgnuradio-pmt",
           "-lboost_system", "-L#{Formula["log4cpp"].opt_lib}", "-llog4cpp",
            testpath/"test.c++", "-o", testpath/"test"
    system "./test"

    (testpath/"test.py").write <<~EOS
      from gnuradio import blocks
      from gnuradio import gr

      class top_block(gr.top_block):
          def __init__(self):
              gr.top_block.__init__(self, "Top Block")
              self.samp_rate = 32000
              s = gr.sizeof_gr_complex
              self.blocks_null_source_0 = blocks.null_source(s)
              self.blocks_null_sink_0 = blocks.null_sink(s)
              self.blocks_head_0 = blocks.head(s, 1024)
              self.connect((self.blocks_head_0, 0),
                           (self.blocks_null_sink_0, 0))
              self.connect((self.blocks_null_source_0, 0),
                           (self.blocks_head_0, 0))

      def main(top_block_cls=top_block, options=None):
          tb = top_block_cls()
          tb.start()
          tb.wait()

      main()
    EOS
    system "python3", testpath/"test.py"
  end
end
