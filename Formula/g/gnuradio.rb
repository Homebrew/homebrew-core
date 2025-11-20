class Gnuradio < Formula
  include Language::Python::Virtualenv

  desc "SDK for signal processing blocks to implement software radios"
  homepage "https://www.gnuradio.org/"
  url "https://github.com/gnuradio/gnuradio/archive/refs/tags/v3.10.12.0.tar.gz"
  sha256 "fe78ad9f74c8ebf93d5c8ad6fa2c13236af330f3c67149d91a0647b3dc6f3958"
  license "GPL-3.0-or-later"
  revision 7
  head "https://github.com/gnuradio/gnuradio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a64188b640c84ef645d1b6f6010e260d9da9e375c096eaf8a001ec13abb65913"
    sha256 cellar: :any,                 arm64_sequoia: "93968c6bb48070749602800d3b5453dbbd9a212f4a2d596e096a11715a1bcef5"
    sha256 cellar: :any,                 arm64_sonoma:  "c492c8c267a1baa972a0e7fb255793d2239ec9e062edb95d814d1d1675b29a1c"
    sha256 cellar: :any,                 sonoma:        "74de839a8cc611b39ba428b1ac4e767e880eaa0950129e9b234b89c2bc2f8e8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3ee509e9eaf734957b3c89c73bfacffa980d341547fb0e7358a8f7cf0e21758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1eceb865928fc15fe1907ac2442860a05801dbb52a05485898a96c7db026d37"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "adwaita-icon-theme"
  depends_on "boost"
  depends_on "cppzmq"
  depends_on "fftw"
  depends_on "fmt"
  depends_on "gmp"
  depends_on "gsl"
  depends_on "gtk+3"
  depends_on "jack"
  depends_on "libsndfile"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "portaudio"
  depends_on "pygobject3"
  depends_on "pyqt@5"
  depends_on "python@3.14"
  depends_on "qt@5" # Qt6 issue: https://github.com/gnuradio/gnuradio/issues/7708
  depends_on "qwt-qt5"
  depends_on "rpds-py"
  depends_on "soapyrtlsdr"
  depends_on "soapysdr"
  depends_on "spdlog"
  depends_on "uhd"
  depends_on "volk"
  depends_on "zeromq"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "alsa-lib"
    depends_on "llvm"
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
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/9e/38/bd5b78a920a64d708fe6bc8e0a2c075e1389d53bef8413725c63ba041535/mako-1.3.10.tar.gz"
    sha256 "99579a6f39583fa7e5630a28c3c1f440e4e97a414b80372649c0ce338da2ea28"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/gnuradio/gnuradio/pull/7904
  patch do
    url "https://github.com/gnuradio/gnuradio/commit/02aa698a05935fe350fb1772226e29605abd335e.patch?full_index=1"
    sha256 "246d540bdd2025b3ad2ffc84adea84b378ea0d640e73809e3f0e48f9bb6d3881"
  end

  def python3
    "python3.14"
  end

  def install
    ENV.cxx11
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    site_packages = Language::Python.site_packages(python3)
    venv = virtualenv_create(libexec/"venv", python3)
    venv.pip_install resources
    ENV.prepend_create_path "PYTHONPATH", venv.root/site_packages

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
      -DPYTHON_EXECUTABLE=#{venv.root}/bin/python
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
    plugin_pth_dir.mkpath

    (venv.site_packages/"homebrew_gr_plugins.py").write <<~PYTHON
      import site
      site.addsitedir("#{plugin_pth_dir}")
    PYTHON

    pth_contents = "#{prefix/site_packages}\nimport homebrew_gr_plugins\n"
    (venv.site_packages/"homebrew-gnuradio.pth").write pth_contents

    # Patch the grc config to change the search directory for blocks
    inreplace etc/"gnuradio/conf.d/grc.conf", share.to_s, "#{HOMEBREW_PREFIX}/share"

    bin.children.reject(&:executable?).map(&:unlink)
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

    boost = Formula["boost"]
    system ENV.cxx, testpath/"test.c++", "-std=c++17", "-I#{boost.opt_include}", "-L#{lib}",
                    "-lgnuradio-blocks", "-lgnuradio-runtime", "-lgnuradio-pmt",
                    "-L#{Formula["fmt"].opt_lib}", "-lfmt",
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
