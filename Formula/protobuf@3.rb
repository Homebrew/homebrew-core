class ProtobufAT3 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.20.3/protobuf-all-3.20.3.tar.gz"
  sha256 "acb71ce46502683c31d4f15bafb611b9e7b858b6024804d6fb84b85750884208"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d78c587c5683c6ef029c414b915276ee0098008028ae6d9905cd42ffc76457a9"
    sha256 cellar: :any,                 arm64_monterey: "6d43d690893a0dc2e18de52be03f748a854f310a89a120314a163cde52d6749e"
    sha256 cellar: :any,                 arm64_big_sur:  "24a6c8831bf3297652ffa6a634886b243ca5709742e39f16b6de9929f22a3b74"
    sha256 cellar: :any,                 ventura:        "c37111bebf0fc900f7b70e3cacc965c52b26263f1e499e0faeabdbed15ea4ccb"
    sha256 cellar: :any,                 monterey:       "04e654c28bac719703534f2b2e44cdba72de4456ba71d6419dd67eb70f04c398"
    sha256 cellar: :any,                 big_sur:        "c19c82512f5b10c0bac857b0ef6db324190d35a8d71388d98689501bfe531054"
    sha256 cellar: :any,                 catalina:       "bb463286e99f61928ced590368aca6b5e3a25892c53a4e0fa0d0e4713b9f2026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e069e9dbb3a04247616c94ed0c0a42dfd96914ab38d89760ed47765a465738a9"
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
