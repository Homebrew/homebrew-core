class Gnuradio < Formula
  include Language::Python::Virtualenv

  desc "SDK for signal processing blocks to implement software radios"
  homepage "https://gnuradio.org/"
  license "GPL-3.0-or-later"
  revision 5
  head "https://github.com/gnuradio/gnuradio.git", branch: "main"

  stable do
    url "https://github.com/gnuradio/gnuradio/archive/refs/tags/v3.10.11.0.tar.gz"
    sha256 "9ca658e6c4af9cfe144770757b34ab0edd23f6dcfaa6c5c46a7546233e5ecd29"

    # Backport support for Boost 1.87.0
    patch do
      url "https://github.com/gnuradio/gnuradio/commit/111a4ff8b868791dae74d8cdf8c1e0684840f51a.patch?full_index=1"
      sha256 "1a18b00346a149562ea2a1c8117039162896eb9ccab3290ed2a7a568ca9b642e"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b5a69ca98194f4a789b67b278e12c5b21a6d55b25759cc1884176c8e26e6015f"
    sha256 cellar: :any,                 arm64_sonoma:  "f3281080346ffc818c23199ad5d04de2888b824b3b9c0410f1a64805e6c7c824"
    sha256 cellar: :any,                 arm64_ventura: "f98f7c0aebad4a933246718e007d6b17cd73e695b4589437ac2ee6ec26ac2d13"
    sha256 cellar: :any,                 sonoma:        "90603f72df66f994cc93b5cf8a551217900fad96053fc8c24d49ffa95b38d617"
    sha256 cellar: :any,                 ventura:       "72ccfe1ec4474abc73d60dafd1a7843f9e99fb172f9e9a94d46d001e7f3db0bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdd9096bf4fd0914ce2b68483a50ec240ab42ee331dfad7bdc3284de9098161d"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "pybind11" => :build
  depends_on "rust" => :build # for rpds-py
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
  depends_on "log4cpp"
  depends_on "numpy"
  depends_on "portaudio"
  depends_on "pygobject3"
  depends_on "pyqt@5"
  depends_on "python@3.13"
  depends_on "qt@5"
  depends_on "qwt-qt5"
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
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "mako" do
    url "https://files.pythonhosted.org/packages/fa/0b/29bc5a230948bf209d3ed3165006d257e547c02c3c2a96f6286320dfe8dc/mako-1.3.6.tar.gz"
    sha256 "9ec3a1583713479fae654f83ed9fa8c9a4c16b7bb0daba0e6bbebff50c0d983d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pygccxml" do
    url "https://files.pythonhosted.org/packages/83/16/36c43ffd40f8b7326bb0d095fc705ccadee2ae0a6e5bcbbfa002185959a2/pygccxml-2.6.0.tar.gz"
    sha256 "7185c55867561e2b1082eadc5ddc3b3019b0328a1fd9e64d4b813a83e06131a6"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/23/80/afdf96daf9b27d61483ef05b38f282121db0e38f5fd4e89f40f5c86c2a4f/rpds_py-0.21.0.tar.gz"
    sha256 "ed6378c9d66d0de903763e7706383d60c33829581f0adff47b6535f1802fa6db"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  def python3
    "python3.13"
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
           "-L#{boost.opt_lib}", "-lboost_system",
           "-L#{Formula["log4cpp"].opt_lib}", "-llog4cpp",
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
