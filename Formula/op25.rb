class Op25 < Formula
  desc "Software-defined analyzer for APCO P25 signals"
  homepage "https://osmocom.org/projects/op25/wiki"
  url "git://op25.osmocom.org/op25.git"

  depends_on "cmake" => :build
  depends_on "cppunit" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "gnuradio"
  depends_on "gr-osmosdr"
  depends_on "itpp"

  def install
    # TODO: apply patch if gnuradio >= 3.8?

    args = std_cmake_args + %w[
      -Wno-dev
    ]

    system "cmake", ".", *args
    system "make"
    system "make", "install"

    # Configure PYTHONPATH for runtime dependencies
    [
      Formula["gnuradio"].lib,
      Formula["gr-osmosdr"].lib,
      lib,
    ].each do |dep|
      Pathname.glob(dep/"python*/site-packages").each do |path|
        ENV.prepend_path "PYTHONPATH", path
      end
    end
    ENV.prepend_path "PYTHONPATH", libexec

    # Needed because sys.path.append breaks when rx.py is called from symlink
    ENV.prepend_path "PYTHONPATH", libexec/"tdma"
    ENV.prepend_path "PYTHONPATH", libexec/"tx"

    libexec.install Dir["#{buildpath}/op25/gr-op25_repeater/apps/**"]

    # FIXME: is this an appropriate way to install?
    bin.install_symlink libexec/"rx.py" => "op25"
    bin.env_script_all_files(libexec, :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <op25/decoder_bf.h>
      #include <op25_repeater/vocoder.h>
      int main() {
        gr::op25::decoder_bf::sptr decoder = gr::op25::decoder_bf::make();

        char* udp_host("/path/to/host");
        gr::op25_repeater::vocoder::sptr vocoder = gr::op25_repeater::vocoder::make(0, 0, 0, udp_host, 0, 0);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lgnuradio-op25", "-lgnuradio-op25_repeater", "-o", "test"
    system "./test"

    system bin/"op25", "--help"
  end
end
