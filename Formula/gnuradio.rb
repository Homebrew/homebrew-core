class Gnuradio < Formula
  include Language::Python::Virtualenv

  desc "SDK for signal processing blocks to implement software radios"
  homepage "https://gnuradio.org/"
  url "https://github.com/gnuradio/gnuradio/archive/refs/tags/v3.10.6.0.tar.gz"
  sha256 "c1a8c09f975d224b27dad9c8e2e7fed1f7cde9bc04d30b004afe8e28bb3f45c6"
  license "GPL-3.0-or-later"
  head "https://github.com/gnuradio/gnuradio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "21ec6d8ffb89878c176bd53f3c42e7735baf9fe0b04852bb55a8aae810571582"
    sha256 cellar: :any,                 arm64_monterey: "b6d3dba0920c7bf9a6ff0edeb9efaa2410e330629fda6b0df030339aff19bba5"
    sha256 cellar: :any,                 arm64_big_sur:  "0ba5721affa4f9a64d2f2a7e292be8adbe8161039f71f7ae5a2cf80c963d7c42"
    sha256 cellar: :any,                 ventura:        "28341e62f1d653db07474e63b3ca10173df5c862978714bc4a37eebd0d320eb6"
    sha256 cellar: :any,                 monterey:       "b65600181e916abcb9042893352bdf192beb7b5d42566f7361789e6d6074269b"
    sha256 cellar: :any,                 big_sur:        "8e88e34a827c2edc81dbce43bedfcf32f19d441e74a8f0e78c64805f096e5170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e7be880643cdad2de225305022ea3ba3d5d3cf9c195423aacba87603c2cfc9b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "pybind11" => :build
  depends_on "adwaita-icon-theme"
  depends_on "boost"
  depends_on "cppzmq"
  depends_on "fftw"
  depends_on "gmp"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "jack"
  depends_on "libsndfile"
  depends_on "libyaml"
  depends_on "log4cpp"
  depends_on "numpy"
  depends_on "portaudio"
  depends_on "pygments"
  depends_on "pygobject3"
  depends_on "pyqt@5"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "qt@5"
  depends_on "qwt-qt5"
  depends_on "six"
  depends_on "soapyrtlsdr"
  depends_on "spdlog"
  depends_on "uhd"
  depends_on "volk"
  depends_on "zeromq"

  fails_with gcc: "5"

  resource "Cheetah3" do
    url "https://files.pythonhosted.org/packages/ee/6f/29c6d74d8536dede06815eeaebfad53699e3f3df0fb22b7a9801a893b426/Cheetah3-3.2.6.tar.gz"
    sha256 "f1c2b693cdcac2ded2823d363f8459ae785261e61c128d68464c8781dba0466b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/05/5f/2ba6e026d33a0e6ddc1dddf9958677f76f5f80c236bd65309d280b166d3e/Mako-1.2.4.tar.gz"
    sha256 "d60a3903dc3bb01a18ad6a89cdbe2e4eadc69c0bc8ef1e3773ba53d44c3f7a34"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  # pygccxml only published a .whl file on PyPi
  resource "pygccxml" do
    url "https://github.com/CastXML/pygccxml/archive/refs/tags/v2.2.1.tar.gz"
    sha256 "9815a12e3bf6b83b2e9d8c88335fb3fa0e2b4067d7fbaaed09c3bf26c6206cc7"
  end

  def install
    python = "python3.11"
    ENV.cxx11

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    venv_root = libexec/"venv"
    site_packages = Language::Python.site_packages(python)
    ENV.prepend_create_path "PYTHONPATH", venv_root/site_packages
    venv = virtualenv_create(venv_root, python)
    venv.pip_install resources

    # Avoid references to the Homebrew shims directory
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    qwt = Formula["qwt-qt5"].opt_lib
    qwt_lib = OS.mac? ? qwt/"qwt.framework/qwt" : qwt/"libqwt.so"
    qwt_include = OS.mac? ? qwt/"qwt.framework/Headers" : Formula["qwt-qt5"].opt_include

    args = %W[
      -DGR_PKG_CONF_DIR=#{etc}/gnuradio/conf.d
      -DGR_PREFSDIR=#{etc}/gnuradio/conf.d
      -DGR_PYTHON_DIR=#{prefix/site_packages}
      -DENABLE_DEFAULT=OFF
      -DPYTHON_EXECUTABLE=#{venv_root}/bin/python
      -DPYTHON_VERSION_MAJOR=3
      -DQWT_LIBRARIES=#{qwt_lib}
      -DQWT_INCLUDE_DIRS=#{qwt_include}
      -DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_lib}
      -DQT_BINARY_DIR=#{Formula["qt@5"].opt_bin}
      -DENABLE_TESTING=OFF
      -DENABLE_INTERNAL_VOLK=OFF
    ]

    enabled = %w[GNURADIO_RUNTIME GRC PYTHON VOLK]
    enabled_modules = %w[GR_ANALOG GR_AUDIO GR_BLOCKS GR_BLOCKTOOL
                         GR_CHANNELS GR_DIGITAL GR_DTV GR_FEC GR_FFT GR_FILTER
                         GR_MODTOOL GR_NETWORK GR_QTGUI GR_SOAPY GR_TRELLIS
                         GR_UHD GR_UTILS GR_VOCODER GR_WAVELET GR_ZEROMQ GR_PDU]
    (enabled + enabled_modules).each do |c|
      args << "-DENABLE_#{c}=ON"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Create a directory for Homebrew to put .pth files pointing to GNU Radio
    # plugins installed by other packages. An automatically-loaded module adds
    # this directory to the package search path.
    plugin_pth_dir = etc/"gnuradio/plugins.d"
    mkdir plugin_pth_dir

    venv_site_packages = venv_root/site_packages

    (venv_site_packages/"homebrew_gr_plugins.py").write <<~EOS
      import site
      site.addsitedir("#{plugin_pth_dir}")
    EOS

    pth_contents = "#{prefix/site_packages}\nimport homebrew_gr_plugins\n"
    (venv_site_packages/"homebrew-gnuradio.pth").write pth_contents

    # Patch the grc config to change the search directory for blocks
    inreplace etc/"gnuradio/conf.d/grc.conf" do |s|
      s.gsub! share.to_s, "#{HOMEBREW_PREFIX}/share"
    end

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
    system ENV.cxx, testpath/"test.c++", "-std=c++11", "-L#{lib}",
           "-lgnuradio-blocks", "-lgnuradio-runtime", "-lgnuradio-pmt",
           "-L#{Formula["boost"].opt_lib}", "-lboost_system",
           "-L#{Formula["log4cpp"].opt_lib}", "-llog4cpp",
           "-L#{Formula["fmt"].opt_lib}", "-lfmt",
           "-o", testpath/"test"
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
    system Formula["python@3.11"].opt_bin/"python3.11", testpath/"test.py"
  end
end
