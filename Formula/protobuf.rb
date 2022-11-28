class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  license "BSD-3-Clause"
  revision 1

  stable do
    url "https://github.com/protocolbuffers/protobuf/releases/download/v21.9/protobuf-all-21.9.tar.gz"
    sha256 "c00f05e19e89b04ea72e92a3c204eedda91f871cd29b0bbe5188550d783c73c7"

    # Fix build with Python 3.11. Remove in the next release.
    patch do
      url "https://github.com/protocolbuffers/protobuf/commit/da973aff2adab60a9e516d3202c111dbdde1a50f.patch?full_index=1"
      sha256 "911925e427a396fa5e54354db8324c0178f5c602b3f819f7d471bb569cc34f53"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dcfd589b02e3c9ca6b0388f013223934413022f6823e39ed2732aec935c0d349"
    sha256 cellar: :any,                 arm64_monterey: "56a18680209f0b28abbb8e0f3c6079446e976b09f24eed9e9a2aaaaed5dbbbf6"
    sha256 cellar: :any,                 arm64_big_sur:  "46955560681fd311617fd17dc92827a7804950fa602514537b12f2b4ee004e85"
    sha256 cellar: :any,                 ventura:        "50343754dd5021305288b7e5ecfff19586beea27e1cab786c03b8dd2086e3a16"
    sha256 cellar: :any,                 monterey:       "1a645d011a09010b7cda09dffb54e97facb516965ad6c90ff56c59ccaa45670d"
    sha256 cellar: :any,                 big_sur:        "42d6f1cdd90ea13c9b5e63106acaa289e781149cd34cc6b1c831e2a64f40e7bd"
    sha256 cellar: :any,                 catalina:       "18c2e746f2a7b2fd85238b0bc7890fb66321ca83c3a67669c0706eb32abff125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fafb7f3058823653ddc5a8b4219ece68ffc441d649f47e240223679e6e94c439"
  end

  head do
    url "https://github.com/protocolbuffers/protobuf.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]

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
    system "./configure", *std_configure_args, "--with-zlib", "--with-pic"
    system "make"
    system "make", "check"
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
      system python, "-c", "import google.protobuf"
    end
  end
end
