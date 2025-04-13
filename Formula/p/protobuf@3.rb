class ProtobufAT3 < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.20.3/protobuf-all-3.20.3.tar.gz"
  sha256 "acb71ce46502683c31d4f15bafb611b9e7b858b6024804d6fb84b85750884208"
  license "BSD-3-Clause"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_sequoia:  "b6215fe7415a0af6a030e42af7cfce3c08b31ca8e29ed0f262989fc7ea38b12f"
    sha256 cellar: :any,                 arm64_sonoma:   "38970c2fb478351045c2c3be21876d4604f83e1ef8d0fab54b38f63a8f43a496"
    sha256 cellar: :any,                 arm64_ventura:  "fc53172db0444cca706a5d2d0283bed72e86536dba717da02822691cde488fb5"
    sha256 cellar: :any,                 arm64_monterey: "6412e052fbeb376013fd0be287332b6bba9d0a1698ca17df4a43c9eaecce468d"
    sha256 cellar: :any,                 sonoma:         "4b52807c8afcdcc00fc8828e747aa9032c0e5a3b00c0674fa0bb71a67cf43985"
    sha256 cellar: :any,                 ventura:        "7dff34237d218a0b9620c28a3a6f28a9fde7a25878f090d99ad1a63439a0c322"
    sha256 cellar: :any,                 monterey:       "6570ec6cd341a8404b54513ed64da009c73e1ef0aac41a077aba4a14ca2a91ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ac89be756fbceabd12ebdd291aa2456af895bc6d329accdd3c0bbe06cb377e5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a0ee63ac3e8f01bd14213820b91d73c6b964982d186f12648063688b3860073"
  end

  keg_only :versioned_formula

  disable! date: "2025-07-01", because: :versioned_formula

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

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
    system "./configure", "--with-zlib", "--with-pic", *std_configure_args
    system "make"
    system "make", "install"

    # Install editor support and examples
    pkgshare.install "editors/proto.vim", "examples"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"

    pip_args = ["--config-settings=--build-option=--cpp_implementation"]
    pythons.each do |python|
      build_isolation = Language::Python.major_minor_version(python) >= "3.12"
      system python, "-m", "pip", "install", *pip_args, *std_pip_args(build_isolation:), "./python"
    end
  end

  test do
    testdata = <<~PROTO
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    PROTO
    (testpath/"test.proto").write testdata
    system bin/"protoc", "test.proto", "--cpp_out=."

    pythons.each do |python|
      with_env(PYTHONPATH: prefix/Language::Python.site_packages(python)) do
        system python, "-c", "import google.protobuf"
      end
    end
  end
end
