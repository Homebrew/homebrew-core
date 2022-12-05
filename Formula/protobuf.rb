class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  license "BSD-3-Clause"

  stable do
    url "https://github.com/protocolbuffers/protobuf/releases/download/v21.11/protobuf-all-21.11.tar.gz"
    sha256 "f045f136e61e367a9436571b6676b94e5e16631a06c864146688c3aaf7df794b"

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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "7b26ae5359fb989cd6fc50e05d4fcf622f2291a9241885a0f01860734cceebdd"
    sha256 cellar: :any,                 arm64_monterey: "3d958a45ab58b6a3365d9db8bef59f37c3d89ffb9e33362a2ea82f8d80626c50"
    sha256 cellar: :any,                 arm64_big_sur:  "09d1eb17559a50e6e072566af5557bb27f6b9b8e61217d05603f59736e02b3ef"
    sha256 cellar: :any,                 monterey:       "86daf1d5f0503a8be1465b7a668d0e3d36a634f5a3d4d02d23adf07a8359a881"
    sha256 cellar: :any,                 big_sur:        "ef7203b8626f6f9f8a7ac1916a26c1f0840eefc2984754cc6b345f78704a99a5"
    sha256 cellar: :any,                 catalina:       "f6728218308e96b523a173e1ad2c7b706bd1225657df20968cc50cc6e32284a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "064f8ca12c10601729bb4f54818a042ae571348adc2cf89000e506fdfb1d933a"
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
