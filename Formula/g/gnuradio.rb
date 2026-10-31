class Gnuradio < Formula
  include Language::Python::Virtualenv

  desc "SDK for signal processing blocks to implement software radios"
  homepage "https://www.gnuradio.org/"
  license "GPL-3.0-or-later"
  revision 13

  stable do
    url "https://github.com/gnuradio/gnuradio/archive/refs/tags/v3.10.12.0.tar.gz"
    sha256 "fe78ad9f74c8ebf93d5c8ad6fa2c13236af330f3c67149d91a0647b3dc6f3958"

    depends_on "pyqt@5" => :no_linkage
    depends_on "qt@5" # Qt6 issue: https://github.com/gnuradio/gnuradio/issues/7708
    depends_on "qwt-qt5"

    # Fix build with Boost 1.89.0
    patch do
      url "https://github.com/gnuradio/gnuradio/commit/02aa698a05935fe350fb1772226e29605abd335e.patch?full_index=1"
      sha256 "246d540bdd2025b3ad2ffc84adea84b378ea0d640e73809e3f0e48f9bb6d3881"
      type :backport
      resolves "https://github.com/gnuradio/gnuradio/pull/7904"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "5fcff9cda85dad90bbe0898e7ef188abd9d25d2e47ecd9de78e2570c431459ab"
    sha256 cellar: :any, arm64_tahoe:       "c58f17fb1842b683ca2b1da90e1ce945ffbcc1a12fd3cd5d06f5f23181d00dcf"
    sha256 cellar: :any, arm64_sequoia:     "3276915ae3de66a9e12a3438d9bf3218c656e597fedcfe7b0d17da500649ec7b"
    sha256 cellar: :any, arm64_sonoma:      "ea636cd143aad90f1ac466764f31e6f6f4c1b51254bca2ba6c192641ac604fe0"
    sha256 cellar: :any, sonoma:            "b9c9ca90bcc5392396f71e22906f037f843cc932966419d185f7a41d4de7e889"
    sha256 cellar: :any, arm64_linux:       "8b67a7f5ec5eddc173271d488f83df23dd102c76c6cad2e626c572ace7de706c"
    sha256 cellar: :any, x86_64_linux:      "a9275f625dc889a850fea0c1a2d74fb4700ece22c1010db2ac8ad2f30b881d92"
  end

  head do
    url "https://github.com/gnuradio/gnuradio.git", branch: "main"

    depends_on "pyqt" => :no_linkage
    depends_on "qtbase"
    depends_on "qwt"
  end

  # Can undeprecate if new release with Qt 6 support is available.
  # TODO: Remove `gr-qtgui` support after 6 months of deprecation if Qt 6 support is not added
  deprecate! date: "2026-05-19", because: "needs end-of-life Qt 5. gr-qtgui support will be removed after 2026-11-19"

  depends_on "cmake" => :build
  depends_on "cppzmq" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "adwaita-icon-theme"
  depends_on "boost"
  depends_on "fftw"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "jack"
  depends_on "libsndfile"
  depends_on "libyaml"
  depends_on "numpy" => :no_linkage
  depends_on "portaudio"
  depends_on "pygobject3" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage
  depends_on "soapysdr"
  depends_on "spdlog"
  depends_on "uhd"
  depends_on "volk"
  depends_on "zeromq"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "alsa-lib"
    depends_on "libunwind"
  end

  pypi_packages package_name:     "",
                exclude_packages: "rpds-py",
                extra_packages:   %w[click jsonschema lxml mako
                                     packaging pygccxml pyyaml setuptools]

  # Resources for Python packages based on .conda/recipe/meta.yaml
  # Currently skipping `matplotlib` and `scipy` extra dependencies.
  #
  # The following are paths where packages are used:
  # * click - gr-utils/modtool/cli/
  # * jsonschema - grc/blocks/json_config.block.yml
  # * lxml - grc/converter/xml.py
  # * mako - grc/
  # * packaging - CMakeLists.txt
  # * pygccxml - gr-utils/blocktool/core/parseheader.py
  # * pyyaml - grc/
  # * setuptools - gr-utils/modtool/cli/base.py

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/5a/09/e07c4b5579a79f4b16f8d4f29f6c54514ac787c4ad506b8c4f28a0e6b0bf/mako-1.4.3.tar.gz"
    sha256 "cd6537fe88d5fec315c55c2f8529bc4ce7a9a352ad7db3eeaa6a66e2dd4ec37a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pygccxml" do
    url "https://files.pythonhosted.org/packages/5e/ef/e2752b28eb259e5ecc82dd1c4063cb0289969fae414d33445b533cc97ea3/pygccxml-3.0.2.tar.gz"
    sha256 "e1a8c738765f4eb2819cc7439975631f838e59a1cf3fa49896e0a1967c5e2bee"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
  end

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    site_packages = Language::Python.site_packages(python3)
    venv = virtualenv_create(libexec/"venv", python3)
    venv.pip_install resources
    ENV.prepend_create_path "PYTHONPATH", venv.root/site_packages

    # Homebrew-specific workaround due to sandbox usage breaking GTK functionality
    inreplace "grc/CMakeLists.txt", "; gi.require_version('Gtk', '3.0');", "; import sys; sys.exit();" if OS.mac?

    # Avoid references to the Homebrew shims directory
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    args = %W[
      -DGR_PKG_CONF_DIR=#{etc}/gnuradio/conf.d
      -DGR_PREFSDIR=#{etc}/gnuradio/conf.d
      -DGR_PYTHON_DIR=#{prefix/site_packages}
      -DENABLE_DEFAULT=OFF
      -DPYTHON_EXECUTABLE=#{venv.root}/bin/python
      -DPYTHON_VERSION_MAJOR=3
      -DENABLE_TESTING=OFF
      -DENABLE_INTERNAL_VOLK=OFF
    ]

    if OS.mac?
      qwt = build.stable? ? "qwt-qt5" : "qwt"
      args += %W[
        -DQWT_LIBRARIES=#{formula_opt_lib(qwt)}/qwt.framework/qwt
        -DQWT_INCLUDE_DIRS=#{formula_opt_lib(qwt)}/qwt.framework/Headers
      ]
    end

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
    bin.children.reject(&:executable?).map(&:unlink)

    # Create a directory for Homebrew to put .pth files pointing to GNU Radio
    # plugins installed by other packages. An automatically-loaded module adds
    # this directory to the package search path.
    plugin_pth_dir = etc/"gnuradio/plugins.d"
    plugin_pth_dir.mkpath

    (venv.site_packages/"homebrew_gr_plugins.py").write <<~PYTHON
      import site
      site.addsitedir("#{plugin_pth_dir}")
    PYTHON

    pth_contents = "#{prefix/site_packages}\nimport homebrew_gr_plugins\n"
    (venv.site_packages/"homebrew-gnuradio.pth").write pth_contents

    # Patch the grc config to change the search directory for blocks
    inreplace etc/"gnuradio/conf.d/grc.conf", share.to_s, "#{HOMEBREW_PREFIX}/share" if build.stable?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gnuradio-config-info -v")

    (testpath/"test.c++").write <<~CPP
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
    CPP

    system ENV.cxx, testpath/"test.c++", "-std=c++17", "-I#{formula_opt_include("boost")}", "-L#{lib}",
                    "-lgnuradio-blocks", "-lgnuradio-runtime", "-lgnuradio-pmt",
                    "-L#{formula_opt_lib("fmt")}", "-lfmt",
                    "-o", testpath/"test"
    system "./test"

    (testpath/"test.py").write <<~PYTHON
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
    PYTHON
    system python3, testpath/"test.py"
  end
end
