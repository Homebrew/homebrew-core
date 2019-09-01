class Gnuradio < Formula
  desc "SDK providing the signal processing runtime and processing blocks"
  homepage "https://gnuradio.org/"
  url "https://www.gnuradio.org/releases/gnuradio/gnuradio-3.8.0.0.tar.xz"
  sha256 "1980b4b5c29679b1c8d0804032e412c9a9cae8dd27362cbe032b9152dc2b852b"
  head "https://github.com/gnuradio/gnuradio.git"

  bottle do
    sha256 "cc4ac0868aa007d57749f3baf89ec2102bd4d45548c1ab556365b89fda140b23" => :mojave
    sha256 "e09af2fcfabfd1421f3b5bba5c6b9778ee87dcbf1dd79b1185ca673dad351ab0" => :high_sierra
    sha256 "3f4527cc5370e051ab78e1dbd2b64bf003934c0e5aae67a467e75f370f0eeff1" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "fftw"
  depends_on "gsl"
  depends_on "log4cpp"
  depends_on "numpy"
  depends_on "orc"
  depends_on "portaudio"
  depends_on "python"
  depends_on "uhd"
  depends_on "zeromq"

  patch do
    url "https://github.com/gnuradio/gnuradio/commit/23bf13685faabe40fed4314534ae71936cdbeece.diff?full_index=1"
    sha256 "777b44aad8db1df5fd7b02cbc09885935f4d8448e6f31b692e70a80b51463c41"
  end

  # cheetah starts here
  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/ac/df/0ae25a9fd5bb528fe3c65af7143708160aa3b47970d5272003a1ad5c03c6/Markdown-3.1.1.tar.gz"
    sha256 "2e50876bcdd74517e7b71f3e7a76102050edec255b3983403f1a63e7c8a41e7a"
  end

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/3e/16/c711180492c9f40fb64dffb436fe1b91e3031637b478edb8de3c4b74097a/Cheetah3-3.2.3.tar.gz"
    sha256 "7c450bce04a82d34cf6d48992c736c2048246cbc00f7b4903a39cf9a8ea3990c"
  end
  # cheetah ends here

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/c4/43/3f1e7d742e2a7925be180b6af5e0f67d38de2f37560365ac1a0b9a04c015/lxml-4.4.1.tar.gz"
    sha256 "c81cb40bff373ab7a7446d6bbca0190bccc5be3448b47b51d729e37799bb5692"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/b0/3c/8dcd6883d009f7cae0f3157fb53e9afb05a0d3d33b3db1268ec2e6f4a56b/Mako-1.1.0.tar.gz"
    sha256 "a36919599a9b7dc5d86a7a8988f23a9a3a3d083070023bab23d64f7f1d1e0a4b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f8/5c/f60e9d8a1e77005f664b76ff8aeaee5bc05d0a91798afd7f53fc998dbc47/Click-7.0.tar.gz"
    sha256 "5b94b49521f6456670fdb30cd82a4eca9412788a93fa6dd6df72c94d5a8ff2d7"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "cppzmq" do
    url "https://raw.githubusercontent.com/zeromq/cppzmq/f5b36e56/zmq.hpp"
    sha256 "cdb75e90ff173e13b060906a63bc42bec6c1c1d8d30944acd7896ab1e7a52498"
  end

  def install
    ENV["CHEETAH_INSTALL_WITHOUT_SETUPTOOLS"] = "1"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    %w[Markdown Cheetah MarkupSafe Mako six click click-plugins].each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    begin
      # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

      resource("lxml").stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    ensure
      ENV.delete("SDKROOT")
    end

    resource("cppzmq").stage include.to_s

    args = std_cmake_args + %W[
      -DGR_PKG_CONF_DIR=#{etc}/gnuradio/conf.d
      -DGR_PREFSDIR=#{etc}/gnuradio/conf.d
      -DENABLE_DEFAULT=OFF
      -DPYTHON_EXECUTABLE=#{Formula["python"].bin}/python3
      -DGR_PYTHON_DIR=lib/python#{xy}/site-packages
    ]

    enabled = %w[DOXYGEN GNURADIO_RUNTIME GR_ANALOG GR_AUDIO GR_BLOCKS
                 GR_CHANNELS GR_DIGITAL GR_DTV GR_FEC GR_FFT GR_FILTER
                 GR_MODTOOL GR_TRELLIS GR_UHD GR_UTILS GR_VOCODER GR_WAVELET
                 GR_ZEROMQ PYTHON SPHINX VOLK]
    enabled.each do |c|
      args << "-DENABLE_#{c}=ON"
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
                    "-L#{Formula["log4cpp"].opt_lib}", "-lgnuradio-blocks",
                    "-lgnuradio-runtime", "-lgnuradio-pmt",
                    "-lboost_system", "-llog4cpp", "test.c++", "-o", "test"
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

    cd testpath do
      system "#{bin}/gr_modtool", "newmod", "test"

      cd "gr-test" do
        system "#{bin}/gr_modtool", "add", "-t", "general", "test_ff", "-l",
               "python", "-y", "--argument-list=''", "--add-python-qa",
               "--copyright=brew"
      end
    end
  end
end
