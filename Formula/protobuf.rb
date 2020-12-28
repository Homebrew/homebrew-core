class Protobuf < Formula
  desc "Protocol buffers (Google's data interchange format)"
  homepage "https://github.com/protocolbuffers/protobuf/"
  url "https://github.com/protocolbuffers/protobuf/releases/download/v3.14.0/protobuf-all-3.14.0.tar.gz"
  sha256 "6dd0f6b20094910fbb7f1f7908688df01af2d4f6c5c21331b9f636048674aebf"
  license "BSD-3-Clause"

  head do
    url "https://github.com/protocolbuffers/protobuf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "b06e8c4247465d7773a359eeeaa39385e564fefab77dbbb245ac928eea334ce9" => :big_sur
    sha256 "67c2e767fbab9efc667ea729cfd08d081a1d3d7e93d7a86f68f8bd4a26ca5e8f" => :arm64_big_sur
    sha256 "8d53111626404e2b4f27718127a313dceea600a74a4d38ffe0870812d8f57eb4" => :catalina
    sha256 "0070627fe9b8c1818e54480c272cc00fa71bd5bd944b04d37ebe2e31604cb9c9" => :mojave
  end

  depends_on "python@3.9" => [:build, :test]

  conflicts_with "percona-server", "percona-xtrabackup",
    because: "both install libprotobuf(-lite) libraries"

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  # Fix build on Big Sur, remove in next version
  # https://github.com/protocolbuffers/protobuf/pull/8126
  patch do
    url "https://github.com/atomiix/protobuf/commit/d065bd6910a0784232dbbbfd3e5806922d69c622.patch?full_index=1"
    sha256 "5433b6247127f9ca622b15c9f669efbaac830fa717ed6220081bc1fc3c735f91"
  end

  def install
    # Don't build in debug mode. See:
    # https://github.com/Homebrew/homebrew/issues/9279
    # https://github.com/protocolbuffers/protobuf/blob/5c24564811c08772d090305be36fae82d8f12bbe/configure.ac#L61
    ENV.prepend "CXXFLAGS", "-DNDEBUG"
    ENV.cxx11

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-zlib"
    system "make"
    system "make", "check"
    system "make", "install"

    # Install editor support and examples
    pkgshare.install "editors/proto.vim", "examples"
    elisp.install "editors/protobuf-mode.el"

    ENV.append_to_cflags "-I#{include}"
    ENV.append_to_cflags "-L#{lib}"

    resource("six").stage do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)
    end
    chdir "python" do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec),
                        "--cpp_implementation"
    end

    version = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    site_packages = "lib/python#{version}/site-packages"
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-protobuf.pth").write pth_contents
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
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import google.protobuf"
  end
end
