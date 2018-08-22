class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  url "https://github.com/ledger/ledger/archive/v3.1.1.tar.gz"
  sha256 "90f06561ab692b192d46d67bc106158da9c6c6813cc3848b503243a9dfd8548a"
  revision 11
  head "https://github.com/ledger/ledger.git"

  bottle do
    sha256 "6e1f061f0d4333c5d00b06ef1ec79173b0f0485818098d6a170e74b8ebdd6537" => :high_sierra
    sha256 "85235b9d9e751e9216b475cc38fa1dc43a8538c18d4fdb918a412ce9c6aadd04" => :sierra
    sha256 "9e28e41459615b80d02f5fa9f2459b7a3f75bd0d4fc0cbb1031b1611fe84c52c" => :el_capitan
  end

  deprecated_option "debug" => "with-debug"

  option "with-debug", "Build with debugging symbols enabled"
  option "with-docs", "Build HTML documentation"
  option "without-python@2", "Build without python support"

  deprecated_option "without-python" => "without-python@2"

  depends_on "cmake" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@2" => :recommended

  resource "boost" do
    url "https://dl.bintray.com/boostorg/release/1.67.0/source/boost_1_67_0.tar.bz2"
    sha256 "2684c972994ee57fc5632e03bf044746f6eb45d4920c343937a465fd67a5adba"
  end

  needs :cxx11

  def install
    resource("boost").stage do
      # Force boost to compile with the desired compiler
      open("user-config.jam", "a") do |file|
        file.write "using darwin : : #{ENV.cxx} ;\n"
      end

      with_libraries = %w[
        date_time
        filesystem
        system
        iostreams
        regex
        test
      ]

      with_libraries << "python" if build.with? "python@2"

      bootstrap_args = %W[
        --prefix=#{libexec}/boost
        --libdir=#{libexec}/boost/lib
        --with-libraries=#{with_libraries.join(",")}
        --without-icu
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

      if build.with? "python@2"
        bootstrap_args << "--with-python=python"
        args << "python=#{Language::Python.major_minor_version "python"}"
      end

      system "./bootstrap.sh", *bootstrap_args
      system "./b2", "headers"
      system "./b2", *args
    end

    Dir["#{libexec}/boost/lib/libboost_*.dylib"].each do |dylib|
      macho = MachO.open(dylib)
      macho.change_dylib_id(dylib)
      macho.dylib_load_commands.map(&:name).map(&:to_s).each do |dylib_name|
        next unless dylib_name =~ /^@loader_path\/libboost_/
        macho.change_dylib(dylib_name, "#{libexec}/boost/lib/#{File.basename dylib_name}")
      end
      macho.write!
    end

    ENV.cxx11

    # Boost >= 1.67 Python components require a Python version suffix
    inreplace "CMakeLists.txt", "set(BOOST_PYTHON python)",
                                "set(BOOST_PYTHON python27)"

    flavor = build.with?("debug") ? "debug" : "opt"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{libexec}/boost
    ]
    args << "--python" if build.with? "python@2"
    args += %w[-- -DBUILD_DOCS=1]
    args << "-DBUILD_WEB_DOCS=1" if build.with? "docs"
    system "./acprep", flavor, "make", *args
    system "./acprep", flavor, "make", "doc", *args
    system "./acprep", flavor, "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    pkgshare.install "python/demo.py" if build.with? "python@2"
    elisp.install Dir["lisp/*.el", "lisp/*.elc"]
    bash_completion.install pkgshare/"contrib/ledger-completion.bash"
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--args-only",
      "--file", "#{pkgshare}/examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
    assert_equal 0, $CHILD_STATUS.exitstatus

    system "python", pkgshare/"demo.py" if build.with? "python@2"
  end
end
