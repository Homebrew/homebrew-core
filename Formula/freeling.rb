class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "http://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.0/FreeLing-4.0.tar.gz"
  sha256 "c79d21c5af215105ba16eb69ee75b589bf7d41abce86feaa40757513e33c6ecf"
  revision 9

  bottle do
    sha256 "ba96339622bec10fe7b19d8898cc323c8d41a72efd35d5154d6bf7d55b5694ea" => :high_sierra
    sha256 "6068c82d410ab3903080aff2809d2f8a6c0e69da166b8d4de813e6b3041a443a" => :sierra
    sha256 "a4ac55575f77608ec3d0f203a8bd68b4337c21fc22810664568091075104158d" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "icu4c"

  conflicts_with "hunspell", :because => "both install 'analyze' binary"

  resource "boost" do
    url "https://dl.bintray.com/boostorg/release/1.64.0/source/boost_1_64_0.tar.bz2"
    sha256 "7bcc5caace97baa948931d712ea5f37038dbb1c5d89b43ad4def4ed7cb683332"
  end

  def install
    resource("boost").stage do
      # Force boost to compile with the desired compiler
      open("user-config.jam", "a") do |file|
        file.write "using darwin : : #{ENV.cxx} ;\n"
      end

      bootstrap_args = %W[
        --without-icu
        --prefix=#{libexec}/boost
        --libdir=#{libexec}/boost/lib
        --with-icu=#{Formula["icu4c"].opt_prefix}
        --with-libraries=program_options,regex,system,thread
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

    icu4c = Formula["icu4c"]
    libtool = Formula["libtool"]
    ENV.append "LDFLAGS", "-L#{libtool.lib}"
    ENV.append "LDFLAGS", "-L#{icu4c.lib}"
    ENV.append "LDFLAGS", "-L#{libexec}/boost/lib"
    ENV.append "CPPFLAGS", "-I#{libtool.include}"
    ENV.append "CPPFLAGS", "-I#{icu4c.include}"
    ENV.append "CPPFLAGS", "-I#{libexec}/boost/include"

    system "autoreconf", "--install"
    system "./configure", "--prefix=#{prefix}", "--enable-boost-locale"
    system "make", "install"

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
