class ProtobufAT3 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.20.3/protobuf-all-3.20.3.tar.gz"
  sha256 "acb71ce46502683c31d4f15bafb611b9e7b858b6024804d6fb84b85750884208"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "c050a7aea5205a7870fead5488375b58b1da52bc50df942c4be9fc8238d81617"
    sha256 cellar: :any,                 arm64_ventura:  "4518b3647024046c1eb5edf36926d38db8fbc7a70f938717b0e9e65d3d272c33"
    sha256 cellar: :any,                 arm64_monterey: "142d9bc74234f930a6c2ed06ac1bef4d0aa55f8edfa8440b26c087c75796050a"
    sha256 cellar: :any,                 arm64_big_sur:  "07a27ece3eb3274cafab5f8cb325a2934945595e0dd766b90921b3860252cc4e"
    sha256 cellar: :any,                 sonoma:         "124fa3fec2a8991fac4f08abe9dfc4e201d74d6a6386271f827532a558473f16"
    sha256 cellar: :any,                 ventura:        "067e3b9caec56ae7a1f2a7d161656ae25f9dbffff618fb7c79fa4f3fa0ab694a"
    sha256 cellar: :any,                 monterey:       "1e46152ab22fccdaa11f553dd9f19447789c59059c5823fc1ac5197081dd62a5"
    sha256 cellar: :any,                 big_sur:        "15b0be2f0afdbed151c1df25ffd28c32fb5c762c15b5b13ca4a42ded0f8bf5ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea79553ddaa109699ce023c377bfe819ffed3c1fbf29d139a26bd01acdb1e74e"
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
    system "./configure", *std_configure_args, "--with-zlib", "--with-pic"
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
