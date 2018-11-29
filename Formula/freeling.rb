class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.1/FreeLing-4.1.tar.gz"
  sha256 "ccb3322db6851075c9419bb5e472aa6b2e32cc7e9fa01981cff49ea3b212247e"
  revision 2

  bottle do
    sha256 "571a7becc49b10d599771a2803b4319e9cf2ee27bdd3ea64aa5d55174d9e8685" => :mojave
    sha256 "6cd3cabd3c23fb08843927e072b296bd30df05bbccedb466228e4226587a3518" => :high_sierra
    sha256 "a60e1efec1b172922f933b84ae900beeff99a0a84537007f9e92b64cecc78ef6" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  conflicts_with "hunspell", :because => "both install 'analyze' binary"

  resource "boost" do
    url "https://dl.bintray.com/boostorg/release/1.68.0/source/boost_1_68_0.tar.bz2"
    sha256 "7f6130bc3cf65f56a618888ce9d5ea704fa10b462be126ad053e80e553d6d8b7"
  end

  def install
    resource("boost").stage do
      # Force boost to compile with the desired compiler
      open("user-config.jam", "a") do |file|
        file.write "using darwin : : #{ENV.cxx} ;\n"
      end

      bootstrap_args = %W[
        --prefix=#{libexec}/boost
        --libdir=#{libexec}/boost/lib
        --with-icu=#{Formula["icu4c"].opt_prefix}
        --with-libraries=atomic,chrono,date_time,filesystem,program_options,regex,system,thread
      ]

      args = %W[
        --prefix=#{libexec}/boost
        --libdir=#{libexec}/boost/lib
        -d2
        -j#{ENV.make_jobs}
        --ignore-site-config
        --layout=tagged
        --user-config=user-config.jam
        install
        threading=multi
        link=shared
        optimization=space
        variant=release
        cxxflags=-std=c++11
      ]

      if ENV.compiler == :clang
        args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
      end

      system "./bootstrap.sh", *bootstrap_args
      system "./b2", "headers"
      system "./b2", *args
    end

    (libexec/"boost/lib").each_child do |dylib|
      MachO::Tools.change_dylib_id(dylib.to_s, dylib.to_s)
    end

    %w[chrono filesystem thread].each do |library|
      macho = MachO.open("#{libexec}/boost/lib/libboost_#{library}-mt.dylib")
      macho.change_dylib("libboost_system-mt.dylib",
                         "#{libexec}/boost/lib/libboost_system-mt.dylib")
      macho.write!
    end

    mkdir "build" do
      system "cmake", "..",  "-DBoost_INCLUDE_DIR=#{libexec}/boost/include",
                             "-DBoost_LIBRARY_DIR_RELEASE=#{libexec}/boost/lib",
                             *std_cmake_args
      system "make", "install"
    end

    libexec.install "#{bin}/fl_initialize"
    inreplace "#{bin}/analyze",
      ". $(cd $(dirname $0) && echo $PWD)/fl_initialize",
      ". #{libexec}/fl_initialize"
  end

  test do
    expected = <<~EOS
      Hello hello NN 1
      world world NN 1
    EOS
    assert_equal expected, pipe_output("#{bin}/analyze -f #{pkgshare}/config/en.cfg", "Hello world").chomp
  end
end
