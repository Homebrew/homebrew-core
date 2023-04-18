class ProtobufAT3 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.20.3/protobuf-all-3.20.3.tar.gz"
  sha256 "acb71ce46502683c31d4f15bafb611b9e7b858b6024804d6fb84b85750884208"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "31354876218ef77ac671b13c34212a9c84145614a593c47b4848584dfdab636a"
    sha256 cellar: :any,                 arm64_monterey: "d91abb041229617f22ca3a362be9ba593607ada03e04ac75107b060a249192c4"
    sha256 cellar: :any,                 arm64_big_sur:  "548504e5e2e2650e0437c24e1809732bf133a1a4c98e0765fe2e9837ce58dca6"
    sha256 cellar: :any,                 ventura:        "6d8651656a282962b2462aef305ee404cc644db13f5ad94b0406a3d008d796f9"
    sha256 cellar: :any,                 monterey:       "793cff3a2716595ed350cc6b2d08dfdb3b5d07165db501dc57639e844648580c"
    sha256 cellar: :any,                 big_sur:        "ed53fe4986cd482e77684dda40b19f7b2712a9fb22fc0e2228cf5522a0631a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6017720f616f2844f85dd48ededb05896e41f5f2e87c32693a22b72b9168f4d1"
  end

  keg_only :versioned_formula

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

  uses_from_macos "zlib"

  # Backport support for Python 3.11
  patch do
    url "https://github.com/protocolbuffers/protobuf/commit/da973aff2adab60a9e516d3202c111dbdde1a50f.patch?full_index=1"
    sha256 "911925e427a396fa5e54354db8324c0178f5c602b3f819f7d471bb569cc34f53"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11

    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--with-zlib"
    system "make"
    system "make", "install"

    # Install editor support and examples
    pkgshare.install "editors/proto.vim", "examples"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"

    cd "python" do
      pythons.each do |python|
        system python, *Language::Python.setup_install_args(prefix, python), "--cpp_implementation"
      end
    end
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."

    pythons.each do |python|
      with_env(PYTHONPATH: prefix/Language::Python.site_packages(python)) do
        system python, "-c", "import google.protobuf"
      end
    end
  end
end
