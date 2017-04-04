class Gnuradio < Formula
  desc "SDK providing the signal processing runtime and processing blocks"
  homepage "https://gnuradio.org/"
  url "https://gnuradio.org/releases/gnuradio/gnuradio-3.7.10.1.tar.gz"
  sha256 "63d7b65cc4abe22f47b8f41caaf7370a0a502b91e36e29901ba03e8838ab4937"
  head "https://github.com/gnuradio/gnuradio.git"

  bottle do
    sha256 "4d064a778aa85bb11b16a9bb3ebcb2c403ab40405ffd54bf50ef35c5d8f14c2d" => :sierra
    sha256 "1578ae20b2b080b2c71e7ff6ffb30179d8896e77853aa68c1266a4ed1eca36c5" => :el_capitan
    sha256 "2125887a9ea16693e55a88ac70b5a3ae9e31df932f3a624169dd2620e53cece5" => :yosemite
  end

  # Fixes linkage of python (swig) bindings directly to python
  # https://github.com/gnuradio/gnuradio/pull/1146
  # Merged into master, probably will be in next release
  patch do
    url "https://github.com/gnuradio/gnuradio/pull/1146.patch"
    sha256 "fbf9842292cc1c2cfcf708d648d01c9a42fb98c5bba542a272dcdac504454d26"
  end

  option "without-python", "Build without python support"

  depends_on "pkg-config" => :build
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on "boost"
  depends_on "cppunit"
  depends_on "fftw"
  depends_on "gsl"
  depends_on "zeromq"
  depends_on "numpy" if build.with? :python
  depends_on "swig" => :build if build.with? :python
  depends_on "cmake" => :build

  # For documentation
  depends_on "doxygen" => [:build, :optional]
  depends_on "sphinx-doc" => [:build, :optional]

  depends_on "uhd" => :recommended
  depends_on "sdl" => :optional
  depends_on "jack" => :optional
  depends_on "portaudio" => :recommended
  depends_on "pygtk" => :optional
  depends_on "wxpython" => :optional

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

    res = %w[Markdown Cheetah lxml]
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    resource("cppzmq").stage include.to_s

    args = std_cmake_args
    args << "-DGR_PKG_CONF_DIR=#{etc}/gnuradio/conf.d"
    args << "-DGR_PREFSDIR=#{etc}/gnuradio/conf.d"

    args << "-DENABLE_DEFAULT=OFF"
    enabled_components = %w[gr-analog gr-fft volk gr-filter gnuradio-runtime
                            gr-blocks testing gr-pager gr-noaa gr-channels
                            gr-audio gr-fcd gr-vocoder gr-fec gr-digital
                            gr-dtv gr-atsc gr-trellis gr-zeromq]
    if build.with? "python"
      enabled_components << "python"
      enabled_components << "gr-utils"
      enabled_components << "grc" if build.with? "pygtk"
      enabled_components << "gr-wxgui" if build.with? "wxpython"
    end
    enabled_components << "gr-wavelet"
    enabled_components << "gr-video-sdl" if build.with? "sdl"
    enabled_components << "gr-uhd" if build.with? "uhd"
    enabled_components << "doxygen" if build.with? "doxygen"
    enabled_components << "sphinx" if build.with? "sphinx"

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
    system("#{bin}/gnuradio-config-info -v")

    (testpath/"test.c++").write <<-EOS.undent
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
    system ENV.cxx,
           "-lgnuradio-blocks", "-lgnuradio-runtime", "-lgnuradio-pmt",
           "-lboost_system",
           (testpath/"test.c++"),
           "-o", (testpath/"test")
    system (testpath/"test")

    if build.with? "python"
      (testpath/"test.py").write <<-EOS.undent
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
      system "python", (testpath/"test.py")

      cd(testpath) do
        system "#{bin}/gr_modtool", "newmod", "test"
        cd("gr-test") do
          system "#{bin}/gr_modtool", "add", "-t", "general", "test_ff", "-l",
                 "python", "-y", "--argument-list=''", "--add-python-qa"
        end
      end
    end
  end
end
