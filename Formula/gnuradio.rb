class Gnuradio < Formula
  include Language::Python::Virtualenv

  desc "SDK for signal processing blocks to implement software radios"
  homepage "https://gnuradio.org/"
  url "https://github.com/gnuradio/gnuradio/archive/refs/tags/v3.9.3.0.tar.gz"
  sha256 "4073ac72524f95fed4bda7dd553cb946f66d2e00bd07c4ae7758f1b787d507e0"
  license "GPL-3.0-or-later"
  revision 4
  head "https://github.com/gnuradio/gnuradio.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "3f2e4e98ec5d75844da29016f2a25143c096bd2f43650dc285b575ea57baf92f"
    sha256 cellar: :any, arm64_big_sur:  "ee526a808f034b85dc969e473d2b2100b4b0cbc8faae550c7438d0f13cc3b173"
    sha256 cellar: :any, monterey:       "23ce9f189acdad914f5533b90de7014a43631a9d635d2b02a0420b4c9c014298"
    sha256 cellar: :any, big_sur:        "d51fa22e7c556761bbd177219f327f0f91e9b30d386960377fcc15d5a1454f8e"
    sha256 cellar: :any, catalina:       "c06f568e76cbb5870eccfd03b6ba566999e91d3fdcc07c2c8e0639bd64ac2e35"
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
  depends_on "log4cpp"
  depends_on "numpy"
  depends_on "portaudio"
  depends_on "pygobject3"
  depends_on "pyqt@5"
  depends_on "python@3.9"
  depends_on "qt@5"
  depends_on "qwt-qt5"
  depends_on "six"
  depends_on "soapyrtlsdr"
  depends_on "uhd"
  depends_on "volk"
  depends_on "zeromq"

  resource "Cheetah3" do
    url "https://files.pythonhosted.org/packages/ee/6f/29c6d74d8536dede06815eeaebfad53699e3f3df0fb22b7a9801a893b426/Cheetah3-3.2.6.tar.gz"
    sha256 "f1c2b693cdcac2ded2823d363f8459ae785261e61c128d68464c8781dba0466b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/d1/42/ff293411e980debfc647be9306d89840c8b82ea24571b014f1a35b2ad80f/Mako-1.1.5.tar.gz"
    sha256 "169fa52af22a91900d852e937400e79f535496191c63712e3b9fda5a9bed6fc3"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  # patch to build with qt6
  # PR ref, https://github.com/gnuradio/gnuradio/pull/5034
  patch do
    url "https://github.com/gnuradio/gnuradio/commit/74bb3881c044d0fe9bb498ede8bcd17f0a27574c.patch?full_index=1"
    sha256 "d5a76e38e9c50ce28d6efddde2ad3612f602879a7edc5161aa8fa7b93756edfd"
  end

  def install
    ENV.cxx11

    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    venv_root = libexec/"venv"
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", "#{venv_root}/lib/python#{xy}/site-packages"
    venv = virtualenv_create(venv_root, "python3")

    %w[Mako Cheetah3 PyYAML click click-plugins].each do |r|
      venv.pip_install resource(r)
    end

    # Avoid references to the Homebrew shims directory
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    args = std_cmake_args + %W[
      -DGR_PKG_CONF_DIR=#{etc}/gnuradio/conf.d
      -DGR_PREFSDIR=#{etc}/gnuradio/conf.d
      -DENABLE_DEFAULT=OFF
      -DPYTHON_EXECUTABLE=#{venv_root}/bin/python
      -DPYTHON_VERSION_MAJOR=3
      -DQWT_LIBRARIES=#{Formula["qwt-qt5"].lib}/qwt.framework/qwt
      -DQWT_INCLUDE_DIRS=#{Formula["qwt-qt5"].lib}/qwt.framework/Headers
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

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    mv Dir[lib/"python#{xy}/dist-packages/*"], lib/"python#{xy}/site-packages/"
    rm_rf lib/"python#{xy}/dist-packages"

    # Create a directory for Homebrew to put .pth files pointing to GNU Radio
    # plugins installed by other packages. An automatically-loaded module adds
    # this directory to the package search path.
    plugin_pth_dir = etc/"gnuradio/plugins.d"
    mkdir plugin_pth_dir

    site_packages = lib/"python#{xy}/site-packages"
    venv_site_packages = venv_root/"lib/python#{xy}/site-packages"

    (venv_site_packages/"homebrew_gr_plugins.py").write <<~EOS
      import site
      site.addsitedir("#{plugin_pth_dir}")
    EOS

    pth_contents = "#{site_packages}\nimport homebrew_gr_plugins\n"
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
    system Formula["python@3.9"].opt_bin/"python3", testpath/"test.py"
  end
end
