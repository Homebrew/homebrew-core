class ProtobufAT3 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.20.1/protobuf-all-3.20.1.tar.gz"
  sha256 "3a400163728db996e8e8d21c7dfb3c239df54d0813270f086c4030addeae2fad"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3951f5b59adfae94b4a6713dca404cb22e02b6a0d7bf59567920c45147a28af0"
    sha256 cellar: :any,                 arm64_big_sur:  "3841a64bfe6cf8095d7cb282e10514a630fe979cb5b464957351771b6b747b8e"
    sha256 cellar: :any,                 monterey:       "7e37643e16e29ad7fc9c68b91d389fb87e72d4f36d875b93e45a1da08fa1d22a"
    sha256 cellar: :any,                 big_sur:        "651bbf4f120fb332c8d1ce7c8b73a8422357ac2c51d223a057140507cc8ae502"
    sha256 cellar: :any,                 catalina:       "32f50ae919d727a1b633a50206370d032b553270373c4d13574707fb232ea151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc3cb502279e7153fba94fdfdb5fbd5ad431c2e9cbfc3928a0e8f570063bf3ff"
  end

  keg_only :versioned_formula

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

  uses_from_macos "zlib"

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
