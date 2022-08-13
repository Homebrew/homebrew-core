class Gnuradio < Formula
  include Language::Python::Virtualenv

  desc "SDK for signal processing blocks to implement software radios"
  homepage "https://gnuradio.org/"
  url "https://github.com/gnuradio/gnuradio/archive/refs/tags/v3.10.3.0.tar.gz"
  sha256 "957108a67ec75d99adaad8f3b10be8ae08760a9cef0b659a5c815a4e33898a75"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/gnuradio/gnuradio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "677c167b0c72083462b7d243a2863c290c003f987eb244bb4f3a5122b575defa"
    sha256 cellar: :any,                 arm64_big_sur:  "6874ed1343a9919b8221bc156a2f70f1c8b3e288ee4c967717ba8c8cbbdbeb1b"
    sha256 cellar: :any,                 monterey:       "74d02c011fb2e52410445658d346c57fb1f29c80c61ad7e2019d48c30ba6c209"
    sha256 cellar: :any,                 big_sur:        "ea346dea13413be03ddb4b646102decc31e8e572501e160432fe6005e48061e9"
    sha256 cellar: :any,                 catalina:       "f72621739965a151a4d95e5c3ec6eb59e83da9333ccf4e2d4d1fb0b5a2146e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b54a723fdb6dea28b8c321a4dfbc4cb28cbf1e6a3768c258c3cf3955210fc2a4"
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
  depends_on "libyaml"
  depends_on "log4cpp"
  depends_on "numpy"
  depends_on "portaudio"
  depends_on "pygobject3"
  depends_on "pyqt@5"
  depends_on "python@3.10"
  depends_on "qt@5"
  depends_on "qwt-qt5"
  depends_on "six"
  depends_on "soapyrtlsdr"
  depends_on "spdlog"
  depends_on "uhd"
  depends_on "volk"
  depends_on "zeromq"

  on_linux do
    depends_on "gcc"
  end

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
    url "https://files.pythonhosted.org/packages/50/ec/1d687348f0954bda388bfd1330c158ba8d7dea4044fc160e74e080babdb9/Mako-1.2.0.tar.gz"
    sha256 "9a7c7e922b87db3686210cf49d5d767033a41d4010b284e747682c92bddd8b39"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  # Fix upstreamed here: https://github.com/gnuradio/gnuradio/pull/6002.
  patch :DATA

  def install
    python = "python3.10"
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

    enabled = %w[GNURADIO_RUNTIME GR_ANALOG GR_AUDIO GR_BLOCKS GRC
                 GR_CHANNELS GR_DIGITAL GR_DTV GR_FEC GR_FFT GR_FILTER
                 GR_MODTOOL GR_NETWORK GR_QTGUI GR_SOAPY GR_TRELLIS
                 GR_UHD GR_UTILS GR_VOCODER GR_WAVELET GR_ZEROMQ PYTHON VOLK]
    enabled.each do |c|
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
    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lgnuradio-blocks",
           "-lgnuradio-runtime", "-lgnuradio-pmt",
           "-L#{Formula["boost"].opt_lib}", "-lboost_system",
           "-L#{Formula["log4cpp"].opt_lib}", "-llog4cpp",
           "-L#{Formula["fmt"].opt_lib}", "-lfmt",
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
    system Formula["python@3.10"].opt_bin/"python3.10", testpath/"test.py"
  end
end

__END__
diff --git a/gr-qtgui/lib/FrequencyDisplayPlot.cc b/gr-qtgui/lib/FrequencyDisplayPlot.cc
index f6f673e..2171f26 100644
--- a/gr-qtgui/lib/FrequencyDisplayPlot.cc
+++ b/gr-qtgui/lib/FrequencyDisplayPlot.cc
@@ -16,7 +16,7 @@
 #include <gnuradio/qtgui/qtgui_types.h>
 #include <qwt_scale_draw.h>
 #include <QColor>
-
+#include <cmath>

 /***********************************************************************
  * Widget to provide mouse pointer coordinate text
diff --git a/gr-qtgui/lib/VectorDisplayPlot.cc b/gr-qtgui/lib/VectorDisplayPlot.cc
index d5c2ecc..e047437 100644
--- a/gr-qtgui/lib/VectorDisplayPlot.cc
+++ b/gr-qtgui/lib/VectorDisplayPlot.cc
@@ -17,6 +17,7 @@
 #include <qwt_legend.h>
 #include <qwt_scale_draw.h>
 #include <QColor>
+#include <cmath>

 #if QWT_VERSION < 0x060100
 #include <qwt_legend_item.h>
diff --git a/gr-qtgui/lib/WaterfallDisplayPlot.cc b/gr-qtgui/lib/WaterfallDisplayPlot.cc
index 69d82fd..d1e42e9 100644
--- a/gr-qtgui/lib/WaterfallDisplayPlot.cc
+++ b/gr-qtgui/lib/WaterfallDisplayPlot.cc
@@ -19,6 +19,7 @@
 #include <qwt_plot_layout.h>
 #include <qwt_scale_draw.h>
 #include <QColor>
+#include <cmath>

 #if QWT_VERSION < 0x060100
 #include <qwt_legend_item.h>
